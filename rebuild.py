#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p fzf bash nix-output-monitor deploy-rs python3 python313Packages.pyfzf

from pyfzf.pyfzf import FzfPrompt
import subprocess

use_submodules = True


def _pipe_to_nom(ps, nom: list[str]):
    print("piping to nom")
    psn = subprocess.Popen(["nom", "--json"] + nom, stdin=ps.stderr)
    psn.communicate()
    ps.wait()
    psn.wait()


def _build_flake_ref(
    flake_dir: str, hostname: str, submodules: bool = use_submodules
) -> str:
    r = flake_dir
    if submodules:
        r += "?submodules=1"
    r += f"#{hostname}"
    return r


def call_nh(
    hosts,
    hostname: str,
    extra_args_nix: list[str],
    nom: list[str] | None,
    flake_dir: str,
    kind: str,
    extra_args_rebuild: list[str],
    submodules: bool = use_submodules,
    checks: bool = True,
):
    args = [
        "nh",
        "os",
        kind,
        _build_flake_ref(flake_dir, hostname, submodules),
    ] + extra_args_rebuild
    if nom is None:
        args += ["--no-nom"]
    if len(extra_args_nix) > 0:
        args += ["--"] + extra_args_nix
    args = list(filter(lambda x: x.strip() != "", args))
    subprocess.run(args, text=True)


# if nom == None -> dont use nom, otherwise pass the specified arguemnts to nom, --json will always be passed
def call_rebuild(
    hosts,
    hostname: str,
    extra_args_nix: list[str],
    nom: list[str] | None,
    flake_dir: str,
    kind: str,
    extra_args_rebuild: list[str],
    submodules: bool = use_submodules,
    checks: bool = True,
):
    args = (
        [
            "nixos-rebuild",
            kind,
            "--flake",
            _build_flake_ref(flake_dir, hostname, submodules),
        ]
        + extra_args_rebuild
        + extra_args_nix
    )
    if nom is not None:
        args += ["--log-format", "internal-json", "-v"]
        args = list(filter(lambda x: x.strip() != "", args))
        ps = subprocess.Popen(args=args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        _pipe_to_nom(ps, nom)
    else:
        args = list(filter(lambda x: x.strip() != "", args))
        subprocess.run(args, text=True)


def call_deploy(
    hosts,
    hostname: str,
    extra_args_nix: list[str],
    nom: list[str] | None,
    flake_dir: str,
    kind: str,
    extra_args_deploy_rs: list[str],
    submodules: bool = use_submodules,
    checks: bool = True,
):
    if not checks:
        extra_args_deploy_rs.append("-s")
    args = (
        ["deploy", _build_flake_ref(flake_dir, hostname, submodules)]
        + extra_args_deploy_rs
        + ["--"]
        + extra_args_nix
    )
    if nom is not None:
        args += ["--log-format", "internal-json", "-v"]
        args = list(filter(lambda x: x.strip() != "", args))
        ps = subprocess.Popen(args=args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        _pipe_to_nom(ps, nom)
    else:
        args = list(filter(lambda x: x.strip() != "", args))
        ps = subprocess.Popen(args=args)


def call_deploy_ssh_stratergy(
    hosts,
    hostname: str,
    extra_args_nix: list[str],
    nom: list[str],
    flake_dir: str,
    kind: str,
    extra_args_deploy_rs: list[str],
    submodules: bool = use_submodules,
    checks: bool = True,
):
    fzf = FzfPrompt()
    ssh_endpoints_names = []
    hostnames = hosts[hostname].get("hostnames", [])
    sel = []
    if len(hostnames) > 0:
        for h in hostnames:
            ssh_endpoints_names.append(h)
        sel = fzf.prompt(ssh_endpoints_names)
    else:
        sel = [hostname]
    if len(sel) == 1:
        sel = sel[0]
        call_deploy(
            hosts,
            sel,
            extra_args_nix,
            nom,
            flake_dir,
            kind,
            extra_args_deploy_rs,
            submodules,
            checks,
        )


def rebuild(
    hosts,
    hostname: str,
    extra_args_nix: list[str] | None,
    nom: list[str] | None,
    flake_dir: str,
    kind: str,
    extra_args_applyer: list[str] | None,
    submodules: bool = use_submodules,
    check: bool = False,
):
    curr_host = hosts[hostname]
    if extra_args_nix is None:
        extra_args_nix = curr_host.get("extra_args_nix", [""])
    if nom is None:
        nom = []
    elif len(nom) == 0:
        nom = curr_host.get("nom", [])
    if extra_args_applyer is None or len(extra_args_applyer) == 0:
        extra_args_applyer = curr_host.get("extra_args_applyer", [])
    curr_host["lambda"](
        hosts,
        hostname,
        extra_args_nix,
        nom,
        flake_dir,
        kind,
        extra_args_applyer,
        submodules,
        check,
    )


def main():
    DEFAULT_NIX_ARGS = ["--accept-flake-config"]
    hosts = {
        "dea": {
            "lambda": call_deploy_ssh_stratergy,
            "hostnames": ["m_dea", "l_dea", "w_dea"],
        },
        "deus": {
            "lambda": call_deploy_ssh_stratergy,
            "hostnames": ["m_deus", "l_deus", "w_deus"],
        },
        "yoga": {
            "lambda": call_rebuild,
        },
        "fabulinus": {
            "lambda": call_deploy_ssh_stratergy,
            "hostnames": ["m_fabulinus", "l_fabulinus", "w_fabulinus"],
        },
        "pons": {
            "lambda": call_deploy_ssh_stratergy,
            # "nom": None,
            # "hostnames": ["m_pons", "l_pons", "w_pons"],
        },
        "thinkpad": {
            "lambda": call_deploy_ssh_stratergy,
            "hostnames": ["m_thinkpad", "l_thinkpad", "w_thinkpad"],
        },
        "thinknew": {
            "lambda": call_deploy_ssh_stratergy,
            "hostnames": ["m_thinknew", "l_thinknew", "w_thinknew"],
        },
    }
    fzf = FzfPrompt()
    host_names = []
    for h in hosts.keys():
        host_names.append(h)
    sel = fzf.prompt(host_names)
    if len(sel) == 1:
        sel = sel[0]
        type = fzf.prompt(["build", "boot", "switch"])
        if len(type):
            nom = hosts[sel].get("nom", [])
            rebuild(
                hosts,
                sel,
                DEFAULT_NIX_ARGS,
                # [] + DEFAULT_NIX_ARGS,
                nom,
                "/home/hannses/.dotfiles",
                type[0],
                None,
            )


main()
