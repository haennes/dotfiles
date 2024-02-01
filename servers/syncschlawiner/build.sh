#!/bin/sh
nix run github:nix-community/nixos-generators -- --format proxmox --configuration configuration.nix -o ./syncschlawiner.vma.zst
