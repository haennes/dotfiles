#!/bin/sh
pushd ~/.dotfiles
sudo nixos-rebuild dry-build --flake .# --show-trace 
popd
