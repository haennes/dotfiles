{ lib, config, ... }:
let
  ports = config.ports.ports.ports;
  ips = config.ips.ips.ips.default;
  create_simple_proxy_with_domain = { fqdn, target_ip, custom_settings ? { }
    , custom_locations ? { }, target_port ? null, https ? false, local ? false
    }:
    let
      target_port_str = (if target_port == null then
        ""
      else
        ":${builtins.toString target_port}");
      https_str = (if https then "s" else "");
    in ({
      services.nginx.virtualHosts."${fqdn}" = {
        enableACME = !local;
        forceSSL = !local;
        listenAddresses = lib.mkIf local [ ips.welt.wg0 ];
        locations."/" = {
          proxyPass = "http${https_str}://${target_ip}${target_port_str}";
          proxyWebsockets = true; # needed if you need to use WebSocket
        } // custom_locations;
      } // custom_settings;
    } // (if (!local) then {
      security.acme.certs.${fqdn}.inheritDefaults = true;
    } else
      { }));
in {
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ports.vertumnus.sshd ports.dea.minecraft ];
  };
} // lib.my.recursiveMerge [
  {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      streamConfig = let port = toString ports.vertumnus.sshd;
      in ''
        upstream ssh-gitea {
            server ${ips.vertumnus.wg0}:${port};
        }

        server {
            listen ${port};
            proxy_pass ssh-gitea;
        }
      '';
      upstreams = {
        tabula = {
          servers = {
            "${ips.tabula_1.wg0}:${toString ports.tabula_1.web}" = {
              fail_timeout = "3s";
              max_fails = 2;
            };
            #"${ips.tabula_2.wg0}:${toString ports.tabula_2.web}" = { };
            "${ips.tabula_3.wg0}:${toString ports.tabula_3.web}" = {
              fail_timeout = "3s";
              max_fails = 2;
            };
          };
        };
        esw = {
          servers = {
            "${ips.fabulinus.wg0}:${toString ports.fabulinus.esw}" = {
              backup = true;
            };
            "${ips.proserpina_1.wg0}:${toString ports.proserpina_1.esw}" = {
              fail_timeout = "3s";
              max_fails = 2;
            };
          };
        };
      };
    };
  }
  (create_simple_proxy_with_domain {
    fqdn = "hannses.de";
    target_ip = "tabula";
    #target_ip = "${ips.tabula_3.wg0}
    #target_port = ports.tabula_3.web;
    custom_locations = {
      #extraConfig = "proxy_set_header Host hannses.de;"; # lfs
    };
  })
  (create_simple_proxy_with_domain {
    fqdn = "git.hannses.de";
    target_ip = ips.vertumnus.wg0;
    target_port = ports.vertumnus.gitea.web;
    custom_settings = {
      extraConfig = "client_max_body_size 20G;"; # lfs
    };
  })
  (create_simple_proxy_with_domain {
    fqdn = "esw.hannses.de";
    target_ip = "esw";
  })
  (create_simple_proxy_with_domain {
    fqdn = "ha1.esw.hannses.de";
    target_ip = ips.proserpina_1.wg0;
    target_port = ports.proserpina_1.esw;
  })
  (create_simple_proxy_with_domain {
    fqdn = "ha2.esw.hannses.de";
    target_ip = ips.fabulinus.wg0;
    target_port = ports.fabulinus.esw;
  })

  (create_simple_proxy_with_domain {
    fqdn = "cloud.hannses.de";
    target_ip = ips.dea.wg0;
    #https = true;
    custom_settings = {
      extraConfig = "client_max_body_size ${config.nextcloud_max_size};";
    };
  })

  (create_simple_proxy_with_domain {
    fqdn = "hyrda.local.hannses.de";
    target_ip = ips.dea.wg0;
    target_port = ports.dea.hydra;
    local = true;
    #https = true;
  })
  (create_simple_proxy_with_domain {
    fqdn = "nix-serve.local.hannses.de";
    target_ip = ips.dea.wg0;
    target_port = ports.dea.nix-serve;
    local = true;
    #https = true;
  })
  #only accessible through wg
  #(create_simple_proxy_with_domain {
  #  fqdn = "kasmweb.hannses.de";
  #  https = true;
  #  target_ip = ips.deus.wg0;
  #  target_port = config.ports.ports.ports.deus.kasmweb.gui;
  #})
  (create_simple_proxy_with_domain {
    fqdn = "mkhh.hannses.de";
    target_ip = ips.tabula.wg0;
  })
  (create_simple_proxy_with_domain {
    fqdn = "cloud.mkhh.hannses.de";
    target_ip = ips.syncschlawiner_mkhh.wg0;
  })
]
