{ lib, config, ... }:
let
  linking = {
    sync = 8384;
    "s.sync" = 8385;
  };
in
{
  # the tasks ones are managed in tasks.nix

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
  services.nginx.virtualHosts= {
    "localhost".locations."/".proxyPass = "http://localhost:${toString config.services.homepage-dashboard.listenPort}";
  } // ( lib.mapAttrs'
      (name: value: {
        name = "${name}.localhost";
        value = { locations."/".proxyPass = "http://localhost:${toString value}";};
      })
  linking );
}
