{
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  ips = osConfig.ips.ips.ips.default;
  ports = osConfig.ports.ports.ports;
  inherit (lib) concatStringsSep mapAttrs;
in
{
  #https://www.reddit.com/r/taskwarrior/comments/1bt1ixi/sync_setup_for_taskwarrior_30/
  #https://gothenburgbitfactory.org/taskserver-troubleshooting/
  programs.taskwarrior = {
    enable = true;
    config =
      let
        vls = [
          "ks"
          "os"
          "db"
          "dd"
        ];
        vls_projects = map (e: "project:${e}") vls;
        vls_projects_not = map (e: "project.not:${e}") vls;
        columns = "id,due,urgency,project,tags,description.count";
        labels = "ID,Due,Urg,Proj,tags,Description";
        sort = "priority-/,project-,description+ ";
      in
      rec {
        sync = {
          server = {
            url = "http://task.local.hannses.de:${toString ports.dea.taskchampion-sync-server}";
          };
        };
        taskd.trust = "ignore task.local.hannses.de";
        report = {
          uni = {
            inherit columns labels sort;
            description = "uni tasks";
            filter = "status:pending and ${concatStringsSep " or " vls_projects}";
          };
          priv = {

            inherit columns labels sort;
            description = "priv tasks";
            filter = "status:pending and ${concatStringsSep " and " vls_projects_not}";
          };
          noproj = {
            inherit columns labels sort;
            description = "tasks without project";
            filter = "status:pending and project: ";
          };
        };
        context =
          { }
          // mapAttrs (_: v: {
            read = v.filter;
            write = "";
          }) report;
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
