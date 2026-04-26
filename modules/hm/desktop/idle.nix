{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.my.desktop.lock) lock_cmd unlock_cmd;
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
in
{
  options.my.desktop.idle.enable = mkEnableOption "idle daemon" // {
    default = config.my.desktop.hyprland.enable;
  };
  config = mkIf config.my.desktop.idle.enable {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          inherit lock_cmd unlock_cmd;

          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";

        };

        listener = [
          {
            timeout = 120;
            on-timeout = "${brightnessctl} -s set 10";
            on-resume = "${brightnessctl} -r";
          }
          {
            timeout = 140;
            on-timeout = ''${pkgs.libnotify}/bin/notify-send -u critical -e -t 10000  -p "about to go to lock" > /tmp/lock_notification'';
            on-restore = ''
              ${pkgs.libnotify}/bin/notify-send -r $(cat /tmp/lock_notification) -t 1 ""
            '';
          }
          {
            timeout = 150;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 300;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
