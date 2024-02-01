#!/bin/sh
nixos-rebuild --target-host root@192.168.0.15 -v switch --flake .#porta 
