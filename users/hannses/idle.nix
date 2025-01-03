{ pkgs, scripts, ... }: {
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 90;
        command = "${scripts.lock} -f --grace 20";
      }
      {
        timeout = 180;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
}
