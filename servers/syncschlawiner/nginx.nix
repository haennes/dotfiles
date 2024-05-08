{ lib, ips, ... }: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      # TODO subdomains
      "${ips.synschlawiner.wg0}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "localhost:80";
          proxyWebsockets = true; # needed if you need to use WebSocket
        };
      };
    };
  };
}
