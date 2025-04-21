{ osConfig, pkgs, ... }:
let
  ips = osConfig.ips.ips.ips.default;
  ports = osConfig.ports.ports.ports;
in {
  #https://www.reddit.com/r/taskwarrior/comments/1bt1ixi/sync_setup_for_taskwarrior_30/
  #https://gothenburgbitfactory.org/taskserver-troubleshooting/
  programs.taskwarrior = {
    enable = true;
    config = {
      sync = {
        server = {
          url = "http://task.local.hannses.de:${
              toString ports.dea.taskchampion-sync-server
            }";
        };
      };
      taskd.trust = "ignore task.local.hannses.de";
    };
    package = pkgs.taskwarrior3;
    extraConfig = ''
      include ${osConfig.age.secrets."taskswarrior-extraConfig.age".path}
    '';
  };
  services.taskwarrior-sync = {
    enable = true;
    package = pkgs.taskwarrior3;
  };
}
