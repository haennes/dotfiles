{name, script, user, interval, ...}:{
  systemd.timers."${name}" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "${interval}";
      OnUnitActiveSec = "${interval}";
      Unit = "${name}.service";
    };
  };

  systemd.services."${name}" = {
    script = script;
    serviceConfig = {
      Type = "oneshot";
      user = user;
    };
  };
}