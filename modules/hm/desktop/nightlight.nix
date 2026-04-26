{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.desktop.nightlight.enable = mkEnableOption "nightlight daemon" // {
    default = config.my.desktop.hyprland.enable;
  };
  config = mkIf config.my.desktop.nightlight.enable {
    services.wlsunset = {
      enable = true;
      temperature = {
        day = 4850;
        night = 3900;
      };
      longitude = 10;
      latitude = 50;
    };
  };
}
