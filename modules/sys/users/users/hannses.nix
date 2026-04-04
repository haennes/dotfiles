{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.my.users.hannses.enable = mkEnableOption "add user hannses" // {
    default = config.is_client;
  };
  config = mkIf config.my.users.hannses.enable {
    users.users."hannses" = {
      isNormalUser = true;
      description = "hannses";
      extraGroups = [
        # keep-sorted start sticky_comments=no block=yes
        "docker"
        "family"
        "libvirtd"
        "networkmanager"
        "vboxusers"
        "video"
        "wheel"
        # keep-sorted end
      ];
    };

  };
}
