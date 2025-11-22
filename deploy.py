#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p fzf bash nix-output-monitor deploy-rs python3 python313Packages.pyfzf

from pyfzf.pyfzf import FzfPrompt
import subprocess

from os import getcwd

use_submodules = True
 
#ps
def _pipe_to_nom(ps, nom: list[str]):
    psn = subprocess.run(["nom", "--json"] + nom, stdin=ps.stdout)
    ps.wait()
    psn.wait()

def _build_flake_ref(flake_dir: str, hostname: str, submodules: bool = use_submodules) -> str:
    r = flake_dir
    if submodules:
        r += "?submodules=1"
    r+=f"#{hostname}"
    return r

# if nom == None -> dont use nom, otherwise pass the specified arguemnts to nom, --json will always be passed
def call_rebuild(hosts, hostname: str, extra_args_nix: str, nom: list[str], flake_dir: str, kind: str,  extra_args_rebuild: list[str], submodules: bool = use_submodules, checks: bool =  True):
    args = ["nixos-rebuild", kind, "--flake", _build_flake_ref(flake_dir, hostname, submodules)] + extra_args_rebuild + ["--", extra_args_nix]
    if nom is not None:
        printf("using nom")
        args.append("--log-format internal-json -v")
        ps =subprocess.run(args, text=True, stdout=subprocess.PIPE)
        _pipe_to_nom(ps, nom)
    else:
        ps = subprocess.run(args, text=True)
        ps.wait()

def call_deploy(hosts, hostname: str, extra_args_nix: str, nom: list[str], flake_dir: str, kind: str,  extra_args_deploy_rs: list[str], submodules: bool = use_submodules, checks: bool =  True):
    if not checks:
        extra_args_deploy_rs.append("-s")
    args = ["deploy", _build_flake_ref(flake_dir, hostname, submodules)] + extra_args_deploy_rs + ["--", extra_args_nix ]
    if nom is not None:
        args.append("--log-format internal-json -v")
        args = filter(lambda x: x.strip() != "", args)
        print(" ".join(args))
        ps =subprocess.run(args, stdout=subprocess.PIPE)
        _pipe_to_nom(ps, nom)

def call_deploy_ssh_stratergy(hosts, hostname: str, extra_args_nix: str, nom: list[str], flake_dir: str, kind: str,  extra_args_deploy_rs: list[str], submodules: bool = use_submodules, checks: bool =  True):
    fzf = FzfPrompt()
    ssh_endpoints_names = []
    for h in hosts[hostname]["hostnames"]:
        ssh_endpoints_names.append(h)
    sel = fzf.prompt(ssh_endpoints_names)
    if len(sel) == 1:
        sel = sel[0]
        call_deploy(hosts, sel, extra_args_nix, nom, flake_dir, kind, extra_args_deploy_rs, submodules, checks)

    




def rebuild(hosts, hostname: str, extra_args_nix: str | None, nom: list[str] | None, flake_dir: str, kind: str,  extra_args_applyer: list[str] | None, submodules: bool = use_submodules, check: bool = False):
    curr_host = hosts[hostname]
    if extra_args_nix is None:
        extra_args_nix = curr_host.get("extra_args_nix", "")
    if len(nom) == 0:
        nom = curr_host.get("nom", [])
    if len(extra_args_applyer) == 0:
        extra_args_applyer = curr_host.get("extra_args_applyer", [])
    curr_host["lambda"](hosts, hostname, extra_args_nix, nom, flake_dir, kind, extra_args_applyer, submodules, check)



def main():
    hosts = {
        "dea": {"lambda": call_deploy_ssh_stratergy, "hostnames": ["m_dea", "l_dea", "w_dea"]},
    }
    fzf = FzfPrompt()
    host_names = []
    for h in hosts.keys():
        host_names.append(h)
    sel = fzf.prompt(host_names)
    if len(sel) == 1:
        sel = sel[0]
        rebuild(hosts, sel, None, [], "~/.dotfiles", "build", [])


    
main()
