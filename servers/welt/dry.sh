#!/bin/sh
nixos-rebuild --target-host welt -v dry-build --flake .#welt 
