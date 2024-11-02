#! /usr/bin/env nix-shell
#! nix-shell -i bash -p wireguard-tools
wg genkey | agenix -e wireguard/$1/wg0/priv.age
ins=$(agenix -d wireguard/$1/wg0/priv.age | wg pubkey)
echo "{key = \"$ins\";}" > wireguard/$1/wg0/pub.nix
nix fmt wireguard/$1/wg0/pub.nix
