{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) str;
in
{
  options.my.desktop.lock = {
    enable = mkEnableOption "locker" // {
      default = config.my.desktop.hyprland.enable;
    };
    lock_cmd = mkOption {
      # provided by this module
      type = str;
      default = "pidof hyprlock || hyprlock ";
    };
    unlock_cmd = mkOption {
      # provided by this module
      type = str;
      default = "pkill -USR1 hyprlock";
    };
  };
  config = mkIf config.my.desktop.lock.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = true;
          immediate_render = true;
          hide_cursor = false;
          no_fade_in = true;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 2;
            blur_size = 7;
          }
        ];

        input-field = [
          {
            monitor = "";

            size = "300, 50";
            outline_thickness = 1;

            font_color = "rgb(b6c4ff)";
            outer_color = "rgba(180, 180, 180, 0.5)";
            inner_color = "rgba(200, 200, 200, 0.1)";
            check_color = "rgba(247, 193, 19, 0.5)";
            fail_color = "rgba(255, 106, 134, 0.5)";

            fade_on_empty = false;
            placeholder_text = "Enter Password";

            dots_spacing = 0.2;
            dots_center = true;
            dots_fade_time = 100;

            shadow_color = "rgba(0, 0, 0, 0.1)";
            shadow_size = 7;
            shadow_passes = 1;

            valign = "center";
            halign = "center";
          }
        ];

        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 150;
            color = "rgb(b6c4ff)";

            position = "0, -25%";

            halign = "center";
            valign = "top";
          }
          {
            monitor = "";
            text = "cmd[update:3600000] date +'%A %d. %b %Y'";
            font_size = 20;
            color = "rgb(b6c4ff)";

            position = "0, -23%";
            halign = "center";
            valign = "top";
          }
        ];
      };
    };
  };
}
