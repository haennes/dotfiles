#! /usr/bin/env nix-shell
#! nix-shell -i bash -p syncthing xmlstarlet ed
syncthing generate --config=.
cat key.pem | agenix -e syncthing/$1/key.age
cat cert.pem | agenix -e syncthing/$1/cert.age

id=$(xmlstarlet sel -t -v '//device[@name]/@id' config.xml)
ins=$(echo ''$1 = \"$id\"\;'')
rm key.pem cert.pem config.xml
sed -i "`wc -l < ./not_so_secret/syncthing.key.nix`i\\$ins\\" ./not_so_secret/syncthing.key.nix
nix fmt ./not_so_secret/syncthing.key.nix
