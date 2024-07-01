{lib,  ... }: {
  imports = [ ./base.nix ./pkgs.nix ./store_optimize.nix ./nm-fix.nix ./acme.nix];

  options = {
    nextcloud_max_size = lib.mkOption{
    };
  };

  config = {
    nextcloud_max_size = "4G";

  };
}
