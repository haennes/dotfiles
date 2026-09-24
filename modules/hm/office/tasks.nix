{
  osConfig,
  config,
  pkgs,
  lib,
  globals,
  ...
}:
let
  ports = osConfig.ports.ports.ports;
  inherit (lib)
    concatStringsSep
    mapAttrs
    mkEnableOption
    mkIf
    mkOption
    ;
  inherit (lib.types)
    str
    ;
in
{
  options.my.office.tasks = {
    enable = mkEnableOption "tasks" // {
      default = config.my.office.enable;
    };
    specialWorkspace = {
      name = mkOption {
        type = str;
        default = "tasks";
      };
      autostart.enable = mkEnableOption "specialWorkspace" // {
        default = true;
      };
    };
  };
  config = mkIf config.my.office.tasks.enable {
    #https://www.reddit.com/r/taskwarrior/comments/1bt1ixi/sync_setup_for_taskwarrior_30/
    #https://gothenburgbitfactory.org/taskserver-troubleshooting/
    programs.taskwarrior = {
      enable = true;
      config =
        let
          vls = [
            # keep-sorted start sticky_comments=no block=yes
            "db"
            "dd"
            "ks"
            "os"
            # keep-sorted end
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

    my.desktop =
    let
      wname = config.my.office.tasks.specialWorkspace.name;
    in 
    mkIf config.my.office.tasks.specialWorkspace.enable {
      wm.common.specialWorkspaces = {
        ${wname} = "t";
      };
      autostart.autostart = mkIf config.my.office.tasks.specialWorkspace.autostart.enable {
        "special:${wname}".tabbed = "${globals.execute_term} ${config.programs.taskwarrior-tui.package}";
      };
    };
  };
}
