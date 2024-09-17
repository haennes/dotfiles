{lib,  ... }: {
  imports = [ ./base.nix ./pkgs.nix ./store_optimize.nix ./acme.nix ./syncthing-wrapper.nix ./wireguard-wrapper.nix];

  options = {
    nextcloud_max_size = lib.mkOption{
    };
  };

  config = {
    nextcloud_max_size = "4G";

  };
}
