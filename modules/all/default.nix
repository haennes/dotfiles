{ lib, ... }: {
  imports = [
    ./acme.nix
    ./base.nix
    ./distributed_builds.nix
    ./crosscompile.nix
    #./fwupd.nix
    ./i18n.nix
    ./nix.nix
    ./pkgs.nix
    ./shell.nix
    ./ssh.nix
    ./store_optimize.nix
    ./syncthing-wrapper.nix
    ./wireguard-wrapper.nix
    ./ports_cli.nix
    ./ips_cli.nix
  ];

  options = { nextcloud_max_size = lib.mkOption { }; };

  config = {
    nextcloud_max_size = "4G";

  };
}
