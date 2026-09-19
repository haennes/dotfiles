{
  config,
  lib,
  pkgs,
  scripts,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  wallpapers = config.home.homeDirectory + "/.wallpapers";
in
{
  options.my.desktop.wallpaper.enable = mkEnableOption "awww wallpaper daemon" // {
    default = config.my.desktop.enable;
  };
  config = mkIf config.my.desktop.wallpaper.enable {
    services.awww.enable = true;

    # random rotation, replaces hyprpaper's per-timeout wallpaper list
    systemd.user.services.awww-rotate = {
      Unit = {
        Description = "random wallpaper rotation";
        PartOf = [ config.wayland.systemd.target ];
        After = [ "awww.service" ];
        Requires = [ "awww.service" ];
      };
      Service = {
        ExecStart = "${scripts.wallpaper} -r 1 -m 2 -t 300 -p ${wallpapers}";
        Restart = "on-failure";
      };
      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}