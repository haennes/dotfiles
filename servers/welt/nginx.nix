{ lib, config, ips, ports, ... }:
let
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
  recursiveMerge = listOfAttrsets:
    lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) { } listOfAttrsets;
in {
  networking.firewall = { allowedTCPPorts = [ 80 443 ]; };
} // recursiveMerge [
  {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
  }
  (create_simple_proxy_with_domain {
    fqdn = "hannses.de";
    target_ip = ips.tabula.wg0;
  })
  (create_simple_proxy_with_domain {
    fqdn = "cloud.hannses.de";
    target_ip = ips.syncschlawiner.wg0;
    custom_settings = {
      extraConfig = "client_max_body_size ${config.nextcloud_max_size};";
    };
  })
  (create_simple_proxy_with_domain {
    fqdn = "kasmweb.hannses.de";
    https = true;
    target_ip = ips.syncschlawiner.wg0;
    target_port = ports.syncschlawiner.kasmweb.gui;
  })
  (create_simple_proxy_with_domain {
    fqdn = "mkhh.hannses.de";
    target_ip = ips.tabula.wg0;
  })
  (create_simple_proxy_with_domain {
    fqdn = "cloud.mkhh.hannses.de";
    target_ip = ips.syncschlawiner_mkhh.wg0;
  })
]
