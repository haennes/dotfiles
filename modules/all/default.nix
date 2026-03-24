{ lib, ... }:
{
  imports = [
              # keep-sorted start
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
    ./nix-serve.nix
    ./minecraft.nix
    #./vms.nix
    #./microvms.nix
    ./watchers
    ./graphics.nix
    ./sudo.nix
    ./networkmanager-networks.nix
              # keep-sorted end
  ];

  options = {
    nextcloud_max_size = lib.mkOption { };
  };

  config = {
    nextcloud_max_size = "4G";

  };
}
