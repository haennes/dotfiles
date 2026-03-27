{ lib, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    #./fwupd.nix
    #./microvms.nix
    #./vms.nix
    ./acme.nix
    ./base.nix
    ./crosscompile.nix
    ./distributed_builds.nix
    ./graphics.nix
    ./i18n.nix
    ./ips_cli.nix
    ./minecraft.nix
    ./networkmanager-networks.nix
    ./nix-serve.nix
    ./nix.nix
    ./pkgs.nix
    ./ports_cli.nix
    ./shell.nix
    ./ssh.nix
    ./store_optimize.nix
    ./sudo.nix
    ./syncthing-wrapper.nix
    ./watchers
    ./wireguard-wrapper.nix
    # keep-sorted end
  ];

  options = {
    nextcloud_max_size = lib.mkOption { };
  };

  config = {
    nextcloud_max_size = "4G";

  };
}
