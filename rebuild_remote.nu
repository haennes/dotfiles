#!/usr/bin/env nu
let op = (nix flake archive .?submodules=1 --to ssh-ng://m_deus --json | from json | $in.path)
print $"($op)"
let cmd = $"nix build ($op)\\?submodules=1\\#nixosConfigurations.yoga.config.system.build.toplevel"
let remote_cmd = $"bash -c \"nix-shell -p git --run '($cmd)'\""
ssh m_deus_noports -o $"RemoteCommand=($remote_cmd)"
let remote_cmd = $"bash -c \"nixos-rebuild switch --flake ($op)\\#yoga --target-host yoga.fritz.box\""
ssh m_deus_noports -o $"RemoteCommand=($remote_cmd)"
systemctl restart --user kanshi waybar
