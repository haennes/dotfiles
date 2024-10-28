{ config, lib, ... }:
let ips = config.ips.ips.ips.default;
in {
  services.nginx.virtualHosts."atuin.localhost" = {
    locations."/" = {
      proxyPass = "http://${ips.historia.wg0}:${
          toString config.ports.ports.ports.historia.atuin
        }";
    };
  };
}
