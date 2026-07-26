#!/usr/bin/env nu
def build-flake-ref [flake_dir: string, target: string, submodules: bool] {
    (if $submodules { $flake_dir + "?submodules=1" } else { $flake_dir }) + $"#($target)"
}

def run-piped [cmd: string, args: list<string>, nom: list<string>] {
    if ($nom | is-empty) {
        ^$cmd ...$args
    } else {
        ^$cmd ...($args ++ ["--log-format" "internal-json" "-v"]) | ^nom --json ...$nom
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
    run-piped "deploy" ([$flake_ref] ++ $a ++ ["--"] ++ $nix_args) $nom
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

    let names = ($hosts | get $hostname | get -o hostnames | default [$hostname])
    let sel = if ($names | length) > 1 { $names | str join "\n" | fzf } else { $names.0 }
    if ($sel | is-not-empty) {
        call-deploy $sel $nix_args $nom $flake_dir $kind $args $submodules $checks
    }
}

# starts a blocking sleep-inhibitor, saves its pid to a unique tmp file, returns the file path
def start-inhibitor [opname: string] {
    let id = $nu.pid
    let pid_pipe = $"/tmp/rebuild-inhibit-($id).pipe"
    let sleep_script = $"/tmp/rebuild-inhibit-($id)-sleep.sh"

    $"#!/usr/bin/env sh
echo $$ >($pid_pipe)
sleep infinity
" | save -f $sleep_script
    chmod +x $sleep_script


    mkfifo $pid_pipe
    job spawn {^systemd-inhibit --what=sleep --why=$opname --who=$'nix rebuild ($id)' --mode=block ($sleep_script) 0>&- &>/tmp/rebuild-inhibit-($id).out &}

    let pid = cat $pid_pipe | str trim | into int

    rm -f $pid_pipe
    return { pid: $pid, sleep_script: $sleep_script }

}

def stop-inhibitor [inhibitor: record<pid: int, sleep_script: path>] {
    kill $inhibitor.pid
    rm -f $inhibitor.sleep_script
}

def rebuild [hosts: record, hostname: string, nix_args: list<string>, nom: list<string>, flake_dir: string, kind: string, args: list<string>, submodules: bool, checks: bool] {
    let h = ($hosts | get $hostname)
    let nix_args = if ($nix_args | is-empty) { $h | get -o extra_args_nix | default [] } else { $nix_args }
    let args = if ($args | is-empty) { $h | get -o extra_args_applyer | default [] } else { $args }
    match ($h | get lambda) {
        "deploy_ssh" => { call-deploy-ssh-strategy $hosts $hostname $nix_args $nom $flake_dir $kind $args $submodules $checks }
        "rebuild" => { call-rebuild $hostname $nix_args $nom $flake_dir $kind $args $submodules }
    }
}

def main [] {
    let default_nix_args = ["--accept-flake-config" $"-j(sys cpu | length)"]
    let hosts = {
        dea:       { lambda: "deploy_ssh", hostnames: [m_dea l_dea g_dea], extra_args_nix: $default_nix_args, extra_args_applyer: ["--remote-build"] },
        deus:      { lambda: "deploy_ssh", hostnames: [m_deus l_deus g_deus], extra_args_nix: $default_nix_args, extra_args_applyer: ["--remote-build"] },
        yoga:      { lambda: "rebuild", extra_args_nix: $default_nix_args },
        fabulinus: { lambda: "deploy_ssh", hostnames: [m_fabulinus l_fabulinus g_fabulinus], extra_args_nix: $default_nix_args, extra_args_applyer: ["--remote-build" "--magic-rollback" "false" "--auto-rollback" "false"] },
        pons:      { lambda: "deploy_ssh", extra_args_nix: $default_nix_args },
        thinkpad:  { lambda: "deploy_ssh", hostnames: [m_thinkpad l_thinkpad g_thinkpad], extra_args_nix: $default_nix_args },
        thinknew:  { lambda: "deploy_ssh", hostnames: [m_thinknew l_thinknew g_thinknew], extra_args_nix: $default_nix_args },
        xaver:     { lambda: "deploy_ssh", hostnames: [m_xaver l_xaver g_xaver "root@172.23.3.19"], extra_args_nix: $default_nix_args },
    }

    let sel = ($hosts | columns | str join "\n" | fzf)
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
    let inhibit = start-inhibitor $"Nix $($opname) @ $($sel)"
    try {
        rebuild $hosts $sel [] $nom "/home/hannses/.dotfiles" $kind [] true false
    }
    stop-inhibitor $inhibit
}
