#!/bin/sh
git add .
sudo -v
sudo nixos-rebuild boot --flake .?submodules=1#$1 --show-trace --log-format internal-json -v |& nom --json
