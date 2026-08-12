#!/usr/bin/env nu
def build-flake-ref [flake_dir: string, target: string, submodules: bool] {
    (if $submodules { $flake_dir + "?submodules=1" } else { $flake_dir }) + $"#($target)"
}

def run-piped [cmd: string, args: list<string>, nom: list<string>] {
    if ($nom | is-empty) {
        ^$cmd ...$args
    } else {
        ^$cmd ...($args ++ ["--log-format" "internal-json" "-v"]) err+out>| ^nom --json ...$nom
    }
}

def call-rebuild [hostname: string, nix_args: list<string>, nom: list<string>, flake_dir: string, kind: string, args: list<string>, submodules: bool] {
    if $kind == "eval" {
        ^nix eval (build-flake-ref $flake_dir $"nixosConfigurations.($hostname).config.system.build.toplevel" $submodules)
        return
    }
    let flake_ref = (build-flake-ref $flake_dir $hostname $submodules)
    run-piped "sudo" (["nixos-rebuild"] ++ [$kind "--flake" $flake_ref] ++ $args ++ $nix_args) $nom
}

def call-deploy [hostname: string, nix_args: list<string>, nom: list<string>, flake_dir: string, kind: string, args: list<string>, submodules: bool, checks: bool] {
    if $kind == "build" {
        call-rebuild $hostname $nix_args $nom $flake_dir $kind $args $submodules
        return
    }
    mut a = $args
    if $kind == "boot" { $a = ($a ++ ["--boot"]) }
    if not $checks { $a = ($a ++ ["-s"]) }
    let flake_ref = (build-flake-ref $flake_dir $hostname $submodules)
    let inhibit = (ssh-start-inhibitor $hostname $"ssh keep alive nix rebuild ($kind)")
    let result = (try { run-piped "deploy" ([$flake_ref] ++ $a ++ ["--"] ++ $nix_args) $nom; "ok" } catch { |e| $e.msg })
    ssh-stop-inhibitor $hostname $inhibit
    if $result != "ok" {
        error make { msg: $result }
    }
}

# pick the ssh target for a host, letting the user choose when there are multiple hostnames
def select-ssh-host [hosts: record, hostname: string] {
    let names = ($hosts | get $hostname | get -o hostnames | default [$hostname])
    if ($names | length) > 1 {
        $names | str join "\n" | fzf
    } else {
        $names.0
    }
}

# copy a git tree's tracked files (incl. submodules, working tree state) via git ls-files into $dest
def copy-git-tree [dir: string, dest: string] {
    mkdir $dest
    if ($"($dir)/.git" | path exists) {
        git -C $dir ls-files --recurse-submodules -z | tar -C $dir --null -T - --ignore-failed-read -cf - | tar -C $dest -xf -
    } else {
        tar -C $dir --exclude=.git -cf - . | tar -C $dest -xf -
    }
}

# checks whether a flake.nix input url points to a local directory
def is-local-input-url [u: string] {
    ($u | str starts-with "/")
    or ($u | str starts-with "git+file://")
    or ($u | str starts-with "file:///")
    or ($u | str starts-with "path:/")
}

# extracts the local directory from a local input url ("" if not absolute)
def local-input-dir [u: string] {
    let rest = if ($u | str starts-with "git+file://") {
        $u | str substring 11..
    } else if ($u | str starts-with "file://") {
        $u | str substring 7..
    } else if ($u | str starts-with "path:") {
        $u | str substring 5..
    } else {
        $u
    }
    let dir = ($rest | split row "?" | first)
    if ($dir | str starts-with "/") { $dir } else { "" }
}

# local (git+file / path) inputs of the flake, copied into $stage/inputs/<slug> and their
# urls in flake.nix rewritten to the corresponding path on the remote host ($tmp_remote)
def stage-local-inputs [stage: string, flake_dir: string, tmp_remote: string] {
    mut content = (open $"($flake_dir)/flake.nix")
    for u in ($content | parse -r 'url = "([^"]+)"' | get capture0) {
        if (not (is-local-input-url $u)) { continue }
        let dir = (local-input-dir $u)
        if ($dir | is-empty) or (not ($dir | path exists)) { continue }
        let slug = ($dir | str replace '^/' '' | str replace '/' '_')
        copy-git-tree $dir $"($stage)/inputs/($slug)"
        $content = ($content | str replace $u $"($tmp_remote)/inputs/($slug)")
    }
    $content | save -f $"($stage)/flake.nix"
}

# stages the local flake working tree (incl. uncommitted changes, submodules, decrypted secrets,
# and local path inputs) into a "flake" subdir of a fresh temp dir on the remote host
def copy-flake-to-remote [host: string, flake_dir: string] {
    let tmp = (^ssh $host "mktemp -d /tmp/nix-flake-XXXXXX" | str trim)
    let stage = (mktemp -d)
    try {
        copy-git-tree $flake_dir $stage
        stage-local-inputs $stage $flake_dir $"($tmp)/flake"
        scp -r -q $stage $"($host):($tmp)/flake"
    } finally {
        rm -rf $stage
    }
    return $tmp
}

def cleanup-remote-flake [host: string, tmp: string] {
    ^ssh $host $"rm -rf ($tmp)"
}

# evaluates a host's configuration on the remote host, from a copy of the flake
def call-remote-eval [host: string, hostname: string, nix_args: list<string>, flake_dir: string] {
    let tmp = (copy-flake-to-remote $host $flake_dir)
    let ref = (build-flake-ref $"($tmp)/flake" $"nixosConfigurations.($hostname).config.system.build.toplevel" false)
    let nix_args = if ($nix_args | any { |x| $x == "--accept-flake-config" }) { $nix_args } else { ["--accept-flake-config"] ++ $nix_args }
    try {
        ^ssh $host ...(["nix" "eval"] ++ $nix_args ++ [$ref])
    } finally {
        cleanup-remote-flake $host $tmp
    }
}

# rebuilds the target on the remote host itself (target == eval host)
def call-remote-rebuild [host: string, hostname: string, nix_args: list<string>, flake_dir: string, kind: string, args: list<string>] {
    let tmp = (copy-flake-to-remote $host $flake_dir)
    let flake_ref = (build-flake-ref $"($tmp)/flake" $hostname false)
    try {
        ^ssh $host ...(["sudo" "nixos-rebuild" $kind "--flake" $flake_ref] ++ $args ++ $nix_args)
    } finally {
        cleanup-remote-flake $host $tmp
    }
}

# deploys a host via deploy-rs running on the remote host (target != eval host)
def call-remote-deploy [host: string, node: string, nix_args: list<string>, flake_dir: string, kind: string, args: list<string>, checks: bool] {
    let tmp = (copy-flake-to-remote $host $flake_dir)
    let flake_ref = (build-flake-ref $"($tmp)/flake" $node false)
    mut a = $args
    if $kind == "boot" { $a = ($a ++ ["--boot"]) }
    if not $checks { $a = ($a ++ ["-s"]) }
    try {
        ^ssh $host ...(["deploy" $flake_ref] ++ $a ++ ["--"] ++ $nix_args)
    } finally {
        cleanup-remote-flake $host $tmp
    }
}

# picks the eval host for a host: explicit eval_host (global or per node) wins,
# otherwise fzf over machines with is_eval_host enabled (encourages this setup)
def resolve-eval-host [hosts: record, hostname: string] {
    let defaults = ($hosts | get -o defaults | default {})
    let explicit = ($hosts | get $hostname | get -o eval_host | default ($defaults | get -o eval_host | default ""))
    if ($explicit | is-not-empty) { return $explicit }
    let candidates = ($hosts | columns | where { |n| $n != "defaults" and (($hosts | get $n | get -o is_eval_host) | default ($defaults | get -o is_eval_host | default false)) })
    if ($candidates | is-empty) { return $hostname }
    $candidates | str join "\n" | fzf
}

# only uses ssh-based deploy-rs when target hostname != actual (current) hostname
def call-deploy-ssh-strategy [hosts: record, hostname: string, nix_args: list<string>, nom: list<string>, flake_dir: string, kind: string, args: list<string>, submodules: bool, checks: bool] {
    if $kind == "build" {
        call-rebuild $hostname $nix_args $nom $flake_dir $kind $args $submodules
        return
    }
    if $kind == "eval" {
        ^nix eval (build-flake-ref $flake_dir $"deploy.nodes.($hostname).profiles.system.path" $submodules)
        return
    }

    let actual = (sys host | get hostname)
    if $hostname == $actual {
        call-rebuild $hostname $nix_args $nom $flake_dir $kind $args $submodules
        return
    }

    let sel = (select-ssh-host $hosts $hostname)
    if ($sel | is-not-empty) {
        call-deploy $sel $nix_args $nom $flake_dir $kind $args $submodules $checks
    }
}

# starts a blocking sleep-inhibitor, saves its pid to a unique tmp file, returns the file path
def start-inhibitor [opname: string] {
    let tmp_dir = (mktemp -d)
    let pid_pipe = $"($tmp_dir)/rebuild-inhibit.pipe"
    let sleep_script = $"($tmp_dir)/rebuild-inhibit-sleep.sh"

    $"#!/usr/bin/env sh
echo $$ >($pid_pipe)
sleep infinity
" | save -f $sleep_script
    chmod +x $sleep_script


    mkfifo $pid_pipe
    job spawn {^systemd-inhibit --what=sleep --why=$"$($opname)" --who=$'nix rebuild ($nu.pid)' --mode=block ($sleep_script) 0>&- &>($tmp_dir)/rebuild-inhibit.out &}

    let pid = cat $pid_pipe | str trim | into int

    rm -f $pid_pipe
    return { pid: $pid, sleep_script: $sleep_script, tmp_dir: $tmp_dir }

}

def stop-inhibitor [inhibitor: record<pid: int, sleep_script: path, tmp_dir: path>] {
    kill $inhibitor.pid
    rm -rf $inhibitor.tmp_dir
}

# starts a blocking sleep-inhibitor entirely on a remote host via ssh,
# returns the remote tmp dir and pid needed to stop it
def ssh-start-inhibitor [hostname: string, opname: string] {
    let why = ($opname | str replace -a " " "-" | str replace -a "'" "")
    let who = $"nix-rebuild-ssh-($nu.pid)"
    let script = '
set -euo pipefail
TMPDIR=$(mktemp -d)
PIPE=$TMPDIR/rebuild-inhibit.pipe
SCRIPT=$TMPDIR/rebuild-inhibit-sleep.sh
printf "%s\n" "#!/usr/bin/env sh" "echo \$\$ > $PIPE" "sleep infinity" > "$SCRIPT"
chmod +x "$SCRIPT"
mkfifo "$PIPE"
setsid systemd-inhibit --what=sleep --why="$1" --who="$2" --mode=block "$SCRIPT" </dev/null >"$TMPDIR/out.log" 2>&1 &
PID=$(timeout 30 cat "$PIPE")
if [ -z "$PID" ]; then
    rm -rf "$TMPDIR"
    exit 1
fi
printf "%s\n" "$TMPDIR" "$PID"
'
    let out = ($script | ^ssh $hostname bash -s -- $why $who)
    let lines = ($out | str trim | lines)
    return { pid: ($lines.1 | into int), tmp_dir: $lines.0 }
}

def ssh-stop-inhibitor [hostname: string, inhibitor: record<tmp_dir: string, pid: int>] {
    $"
set -euo pipefail
kill ($inhibitor.pid) 2>/dev/null || true
rm -rf ($inhibitor.tmp_dir)
" | ^ssh $hostname bash -s
}

def rebuild [hosts: record, hostname: string, nix_args: list<string>, nom: list<string>, flake_dir: string, kind: string, args: list<string>, submodules: bool, checks: bool] {
    let h = ($hosts | get $hostname)
    let nix_args = if ($nix_args | is-empty) { $h | get -o extra_args_nix | default [] } else { $nix_args }
    let args = if ($args | is-empty) { $h | get -o extra_args_applyer | default [] } else { $args }
    let defaults = ($hosts | get -o defaults | default {})
    let remote_eval = ($h | get -o remote_eval | default ($defaults | get -o remote_eval | default false))
    if $remote_eval {
        let eval_host = (resolve-eval-host $hosts $hostname)
        if ($eval_host | is-empty) { return }
        let sel = (select-ssh-host $hosts $eval_host)
        if ($sel | is-empty) { return }
        if $kind == "eval" {
            call-remote-eval $sel $hostname $nix_args $flake_dir
            return
        }
        if ($hostname == $eval_host) and ($hostname == (sys host | get hostname)) {
            call-rebuild $hostname $nix_args $nom $flake_dir $kind $args $submodules
            return
        }
        if $hostname == $eval_host {
            call-remote-rebuild $sel $hostname $nix_args $flake_dir $kind $args
            return
        }
        let node = (select-ssh-host $hosts $hostname)
        if ($node | is-empty) { return }
        call-remote-deploy $sel $node $nix_args $flake_dir $kind $args $checks
        return
    }
    match ($h | get lambda) {
        "deploy_ssh" => { call-deploy-ssh-strategy $hosts $hostname $nix_args $nom $flake_dir $kind $args $submodules $checks }
        "rebuild" => { call-rebuild $hostname $nix_args $nom $flake_dir $kind $args $submodules }
    }
}

def main [] {
    let default_nix_args = ["--accept-flake-config" $"-j(sys cpu | length)"]
    # remote_eval: host is evaluated and built on an eval host instead of locally (recommended).
    #   the local flake tree (incl. uncommitted changes) is copied to a temp dir on the eval host first
    #   target == eval host -> nixos-rebuild on the eval host
    #   target != eval host -> deploy-rs running on the eval host
    # is_eval_host: machine can act as eval host for other hosts.
    # eval_host: explicit eval host for a host; if unset one is picked from the eval hosts.
    let hosts = {
        defaults: {
            remote_eval: false,
            is_eval_host: false,
        },
        dea:       { lambda: "deploy_ssh", hostnames: [m_dea l_dea g_dea], extra_args_nix: $default_nix_args, extra_args_applyer: ["--remote-build"] },
        deus:      { lambda: "deploy_ssh", hostnames: [m_deus l_deus g_deus], extra_args_nix: $default_nix_args, extra_args_applyer: ["--remote-build"] },
        yoga:      { lambda: "rebuild", extra_args_nix: $default_nix_args },
        fabulinus: { lambda: "deploy_ssh", hostnames: [m_fabulinus l_fabulinus g_fabulinus], extra_args_nix: $default_nix_args, extra_args_applyer: ["--remote-build" "--magic-rollback" "false" "--auto-rollback" "false"] },
        pons:      { lambda: "deploy_ssh", extra_args_nix: $default_nix_args },
        thinkpad:  { lambda: "deploy_ssh", hostnames: [m_thinkpad l_thinkpad g_thinkpad], extra_args_nix: $default_nix_args },
        thinknew:  { lambda: "deploy_ssh", hostnames: [m_thinknew l_thinknew g_thinknew], extra_args_nix: $default_nix_args },
        xaver:     { lambda: "deploy_ssh", hostnames: [m_xaver l_xaver g_xaver "root@172.23.3.19"], extra_args_nix: $default_nix_args },
    }

    let sel = ($hosts | columns | where { |h| $h != "defaults" } | str join "\n" | fzf)
    if ($sel | is-empty) { return }
    let kind = (["build" "boot" "switch" "eval"] | str join "\n" | fzf)
    if ($kind | is-empty) { return }
    let nom = ($hosts | get $sel | get -o nom | default [])

    
    let opname = match $kind {
        "build" => $"rebuild build"
        "boot" => $"rebuild boot"
        "switch" => $"rebuild switch"
        "eval" => $"eval"
    }
    let inhibit = start-inhibitor $"Nix ($opname) @ ($sel)"
    try {
        rebuild $hosts $sel [] $nom "/home/hannses/.dotfiles" $kind [] true false
    }
    stop-inhibitor $inhibit
}
