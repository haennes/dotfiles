{ lib, config, ... }:
let
  ports = config.ports.ports.ports;
  ips = config.ips.ips.ips.default;
  create_simple_proxy_with_domain = { fqdn, target_ip, custom_settings ? { }
    , custom_locations ? { }, target_port ? null, https ? false }:
    let
      target_port_str = (if target_port == null then
        ""
      else
        ":${builtins.toString target_port}");
      https_str = (if https then "s" else "");
    in {
      security.acme.certs."${fqdn}" = { inheritDefaults = true; };
      services.nginx.virtualHosts."${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http${https_str}://${target_ip}${target_port_str}";
          proxyWebsockets = true; # needed if you need to use WebSocket
        } // custom_locations;
      } // custom_settings;
    };
in {
  networking.firewall = { allowedTCPPorts = [ 80 443 ports.vertumnus.sshd ]; };
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
    };
  }
  (create_simple_proxy_with_domain {
    fqdn = "hannses.de";
    target_ip = ips.tabula.wg0;
  })
  (create_simple_proxy_with_domain {
    fqdn = "git.hannses.de";
    target_ip = ips.vertumnus.wg0;
    target_port = ports.vertumnus.gitea.web;
  })
  (create_simple_proxy_with_domain {
    fqdn = "cloud.hannses.de";
    target_ip = ips.concordia.wg0;
    https = true;
    custom_settings = {
      extraConfig = "client_max_body_size ${config.nextcloud_max_size};";
    };
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
