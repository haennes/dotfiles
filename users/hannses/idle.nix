{ pkgs, scripts, ... }:
let brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
in {
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "${scripts.lock} -f";
        unlock_cmd = "pkill -USR1 swaylock";

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
          on-timeout = ''
            ${pkgs.libnotify}/bin/notify-send -u critical -e -t 10000 "about to go to lock"'';
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
}
