{ lib, config, ... }:
let
proxmox_password = import ../../secrets/proxmox_password.nix;
cfg = config.services.homepage-dashboard;
auto_columns = name: lib.length (lib.elemAt (lib.attrValues (lib.findFirst(item: (lib.attrNames item) == [name]) {"" = [];} cfg.services)) 0 );
in
{
  services.homepage-dashboard = {
    enable = true;
    settings = {
      background =
        "https://images.unsplash.com/photo-1502790671504-542ad42d5189?auto=format&fit=crop&w=2560&q=80";
      theme = "dark";
      color = "slate";
      layout = {
        Tasks = {
          style = "row";
          columns = lib.length config.services.tasks_md.conf;
        };
        Syncthing = {
          style = "row";
          columns = auto_columns "Syncthing";
        };
        Homepage = {
          style = "row";
          columns = auto_columns "Homepage";
        };
      };
    };
    services = [
      {
        "Tasks" = map (item: {"${item.title}".href = "http://localhost/${item.base_path}";}) config.services.tasks_md.conf;
      }
      {
        "Syncthing" = [
          {
            "syncschlawiner" = { href = "http://localhost:8385"; };
          }
          { "local" = { href = "http://localhost:8384"; }; }
        ];
      }
      {
        "Homepage" = [
          {
            "homepage" = {
              href = "https://hannses.de/";
            };

          }
          { "nextcloud" = { href = "http://cloud.hannses.de/"; }; }
        ];
      }
      #{
      #  "Server" = {
      #    "PVE" = {
      #
      #      href = "http://localhost:8006";
      #      widget = {
      #        type = "proxmox";
      #        url = "http://localhost:8006";
      #        username = "dashboard-user-api@pam!hompage-token";
      #        password = proxmox_password;
      #        fields = ["vms"];
      #      };
      #    };
      #  };
      #}
    ];
    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
    ];
  };
}
