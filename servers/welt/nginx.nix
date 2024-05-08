{ lib, config, ips, ... }:
let
  create_simple_proxy_with_domain =
    { fqdn, target_ip, custom_settings ? { }, custom_locations ? { } }: {
      security.acme.certs."${fqdn}" = { inheritDefaults = true; };
      services.nginx.virtualHosts."${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://${target_ip}";
          proxyWebsockets = true; # needed if you need to use WebSocket
          #extraConfig =
          ## required when the target is also TLS server with multiple hosts
          #"proxy_ssl_server_name on;" + # required when the server wants to use HTTP Authentication
          #"proxy_pass_header Authorization;"
          #;
        } // custom_locations;
      } // custom_settings;
    };
  recursiveMerge = listOfAttrsets:
    lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) { } listOfAttrsets;
in {

} // recursiveMerge [
  {
    security.acme = {
      acceptTerms = true;
      defaults.email = "vegsy5q8@anonaddy.me";
    };
  }
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
  })
  #(create_simple_proxy_with_domain{fqdn = "mail.hannses.de"; target_ip = ips.tabula.wg0;})
  (create_simple_proxy_with_domain {
    fqdn = "mkhh.hannses.de";
    target_ip = ips.tabula.wg0;
  })
  (create_simple_proxy_with_domain {
    fqdn = "cloud.mkhh.hannses.de";
    target_ip = ips.syncschlawiner_mkhh.wg0;
  })
  #(create_simple_proxy_with_domain{fqdn = "cloud.mkhh.hannses.de"; target_ip = ips.tabula.wg0;})
]
