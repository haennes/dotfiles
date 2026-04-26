{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.desktop.wallpaper.enable = mkEnableOption "wallpaper" // {
    default = config.my.desktop.hyprland.enable;
  };
  config = mkIf config.my.desktop.wallpaper.enable {
    home.packages = with pkgs; [
      swww
    ];
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        wallpaper = [
          {
            timeout = 5 * 60;
            fit_mode = "cover";
            path = config.home.homeDirectory + "/.wallpapers";
          }
        ];
      };
    };
  };
}
