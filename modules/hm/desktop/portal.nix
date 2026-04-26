{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.desktop.portal.enable = mkEnableOption "desktop portal" // {
    default = config.my.desktop.enable;
  };
  config = mkIf config.my.desktop.portal.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
      # wlr.enable = true;
    };
    home.packages = with pkgs; [
      xdg-desktop-portal-hyprland # maybe replace with home manager (not hyprland)
    ];
  };
}
