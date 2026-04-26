{ lib, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    #./fwupd.nix
    #./vms.nix
    ./acme.nix
    ./base.nix
    ./crosscompile.nix
    ./distributed_builds.nix
    ./minecraft.nix
    ./nix-serve.nix
    ./nix.nix
    ./pkgs.nix
    ./shell.nix
    ./store_optimize.nix
    ./syncthing-wrapper.nix
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
