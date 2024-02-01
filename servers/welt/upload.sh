#!/bin/sh
nixos-rebuild --target-host welt -v switch --flake .#welt 
