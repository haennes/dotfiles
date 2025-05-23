{ lib, config, sshkeys, ... }:
let
  hports = config.ports.ports.curr_ports;
  proxmox_password = import ../../secrets/not_so_secret/proxmox_password.nix;
  nc_key = import ../../secrets/not_so_secret/nc_password.nix;
  link = import ../../secrets/not_so_secret/tt_link.nix;
  cfg = config.services.homepage-dashboard;
  auto_columns = name:
    lib.length (lib.elemAt (lib.attrValues
      (lib.findFirst (item: (lib.attrNames item) == [ name ]) { "" = [ ]; }
        cfg.services)) 0);
in {
  services.autossh.sessions = let aports = hports.autossh-monitoring;
  in [
    {
      user = "hannses";
      name = "pve";
      monitoringPort = aports.pve;
      extraArguments = ''
        -v -A -N -o "IdentitiesOnly=yes" -i ${sshkeys.forward_path} g_forward_pve'';
    }
    {
      user = "hannses";
      name = "syncschlawiner";
      monitoringPort = aports.syncschlawiner;
      extraArguments = ''
        -v -A -N -o "IdentitiesOnly=yes" -i ${sshkeys.forward_path} g_forward_syncschlawiner'';
    }
  ];
  services.nginx.virtualHosts."cdn.localhost".locations."/" = {
    root = "/local_cdn";
  };
  services.homepage-dashboard = {
    #fix for update breaking: https://github.com/NixOS/nixpkgs/issues/346016
    listenPort = hports.homepage-dashboard;
    enable = true;
    allowedHosts = "localhost:${toString hports.homepage-dashboard},localhost";
    settings = {
      background = "http://cdn.localhost/bg.png";
      theme = "dark";
      color = "slate";
      target = "_blank"; # open in new tab
      statusStyle = "dot";
      layout = {
        Tasks = {
          style = "row";
          columns = lib.length config.services.tasks_md.conf;
        };
        Syncthing = {
          icon = "si-syncthing-#0891D1";
          style = "row";
          columns = auto_columns "Syncthing";
        };
        Homepage = {
          style = "row";
          columns = auto_columns "Homepage";
        };
        Uni = {
          icon = "http://cdn.localhost/OTH-logo.jpg";
          style = "row";
          columns = auto_columns "Uni";
        };
        FSIM = {
          style = "row";
          columns = auto_columns "FSIM";
        };
        "bahn.expert" = {
          style = "row";
          columns = 2;
          #columns = auto_columns "bahn.expert" / 2;
          #style = "columns";
          #rows = 2;
        };
        "Server" = {
          style = "row";
          columns = auto_columns "Server";
        };
        "TT" = {
          style = "row";
          columns = auto_columns "TT";
        };
      };
    };
    services = let tasks_md = config.services.tasks_md;
    in (lib.optional tasks_md.enable {
      "Tasks" = map (item: {
        "${item.title}" = rec {
          icon = "mdi-check-#1CDC18";
          href = "http://${item.domain}/${item.base_path}";
          siteMonitor = href;
        };
      }) tasks_md.conf;
    }) ++ [

      {
        "Syncthing" = [
          #TODO consider adding more here / waiting for upstream syncthing support
          #https://github.com/gethomepage/homepage/issues/812
          {
            "local" = rec {
              icon = "si-syncthing-#0891D1";
              href = "http://sync.localhost";
              siteMonitor = href;
            };
          }
        ];
      }
      {
        "Homepage" = [
          {
            "homepage" = {
              href = "https://hannses.de/";
              siteMonitor = "https://hannses.de/";
              #ping = "hannses.de";
            };

          }

          {
            "proton" = {
              icon = "si-protonmail-#6D4AFF";
              href = "https://mail.proton.me/u/2/inbox";
            };
          }
          {
            "discord" = {
              icon = "si-discord-#5865F2";
              href = "https://discord.com/channels/@me";
            };
          }
          #{ "bahn expert" = { href = "https://bahn.expert/routing"; }; }
        ];
      }
      {
        "TT" = [
          {
            "Trainingskalender" = {
              icon = "mdi-calendar-month-#FFFFFF";
              href = link.cal;
            };

          }
          {
            "click-TT" = {
              icon = "https://www.mytischtennis.de/favicon.ico";
              href = link.click_tt;
            };
          }
        ];
      }
      {
        "Uni" = [
          {
            "homepage" = {
              icon = "http://cdn.localhost/OTH-logo.jpg";
              href = "https://oth-regensburg.de/";
            };
          }
          {
            "units" = {
              icon = "https://kephiso.webuntis.com/favicon.ico";
              href =
                "https://kephiso.webuntis.com/WebUntis/index.do#/basic/login";
            };
          }
          {
            "mensa" = {
              icon = "mdi-food-#974F00";
              href =
                "https://www.imensa.de/regensburg/mensa-oth-regensburg/index.html";
            };
          }
          {
            "elearning" = {
              icon =
                "https://elearning.oth-regensburg.de/pluginfile.php/1/theme_boost_union/favicon/64x64/1714636855/ELO_favicon-02.png";
              href = "https://elearning.oth-regensburg.de/";
            };
          }
          {
            "hisinone" = {
              icon =
                "https://www.his.de/typo3conf/ext/vc_theme/Resources/Public/Graphics/Extensions/Favicons/android-icon-192x192.png";
              href =
                "https://hisinone-studium.oth-regensburg.de/qisserver/pages/cs/sys/portal/hisinoneStartPage.faces";
            };
          }
        ];
      }
      {
        "FSIM" = [
          {
            "fsim" = {
              icon = "https://www.fsim-ev.de/favicon.ico";
              href = "https://www.fsim-ev.de/";
            };
          }
          {
            "cloud fsim" = {
              icon = "si-nextcloud-#0082C9";
              href = "https://cloud.fsim-ev.de/";
            };
          }
          {
            "zulip" = {
              icon = "si-zulip-#6492FE";
              href = "https://chat.fsim-ev.de";
            };
          }
        ];
      }
      {
        "bahn.expert" = [
          {
            "buchloe-regensburg" = {
              icon = "si-deutschebahn-#FF0000";
              href = "https://bahn.expert/routing/8000057/8000309";
            };
          }
          {
            "regensburg-buchloe" = {
              icon = "si-deutschebahn-#FF0000";
              href = "https://bahn.expert/routing/8000309/8000057";
            };
          }
          {
            "buchloe-münchen" = {
              icon = "si-deutschebahn-#FF0000";
              href = "https://bahn.expert/routing/8000057/8000261/";
            };
          }
          {
            "münchen-buchloe" = {
              icon = "si-deutschebahn-#FF0000";
              href = "https://bahn.expert/routing/8000261/8000057/";
            };
          }
          {
            "münchen-regensburg" = {
              icon = "si-deutschebahn-#FF0000";
              href = "https://bahn.expert/routing/8000261/8000309/";
            };
          }
          {
            "regensburg-münchen" = {
              icon = "si-deutschebahn-#FF0000";
              href = "https://bahn.expert/routing/8000309/8000261/";
            };
          }
        ];
      }
      {
        "Server" = [{
          "nextcloud" = {
            icon = "si-nextcloud-#0082C9";
            href = "https://cloud.hannses.de/";
            siteMonitor = "https://cloud.hannses.de/";
            statusStyle = "dot";
            widget = {
              type = "nextcloud";
              url = "https://cloud.hannses.de";
              key = nc_key;
              fields = [ "freespace" "activeusers" "numfiles" "numshares" ];
            };
          };
        }];
      }
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
          provider = "custom";
          url = "https://www.ecosia.org/search?q=";
          target = "_blank";
          suggestionUrl =
            "https://ac.ecosia.org/autocomplete?type=list&q="; # Optional
          showSearchSuggestions = true; # Optional
        };
      }
      {
        openmeteo = {
          label = "Regensburg"; # optional
          latitude = 49.00042;
          longitude = 12.10772;
          timezone = "Europe/Berlin"; # optional
          units = "metric"; # or imperial
          cache =
            5; # Time in minutes to cache API responses, to stay within limits
          format = { # optional, Intl.NumberFormat options
            maximumFractionDigits = 1;
          };
        };
      }
    ];
  };
}
