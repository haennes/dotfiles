{ lib, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    #./vms.nix
    ./base.nix
    ./minecraft.nix
    ./nix-serve.nix
    ./pkgs.nix
    ./shell.nix
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
