{ config, lib, ... }:
{
  config = lib.mkIf config.has_battery {
    systemd.services.low-battery-hybrid-sleep = {
      description = "Hybrid sleep on critical battery";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      script = ''
        capacity=$(cat /sys/class/power_supply/BAT0/capacity)
        status=$(cat /sys/class/power_supply/BAT0/status)

        if [ "$status" = "Discharging" ] && [ "$capacity" -le 3 ]; then
          systemctl hybrid-sleep
        fi
      '';
    };

    systemd.timers.low-battery-hybrid-sleep = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2m";
        OnUnitActiveSec = "1m";
        Unit = "low-battery-hybrid-sleep.service";
      };
    };
    services.power-profiles-daemon.enable = true;
  };
}
