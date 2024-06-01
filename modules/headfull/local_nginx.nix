{ lib, config, ... }:
let
linking = {
      #TODO make this auto-updating
      "/syncschlawiner_syncthing" = 8385;
      "/syncschlawiner_web_80" = 8386;
      "/synscchlawiner_web_443" = 8387;
      #"/home" = config.services.homepage-dashboard.listenPort;
      "/" = config.services.homepage-dashboard.listenPort;
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
    "localhost".locations = {
      "/" = {
       proxyPass = "http://localhost:${toString config.services.homepage-dashboard.listenPort}";
      };
      "/syncthing" = {return = "308 http://localhost:8384";};
    };
    "sync.localhost".locations."/" = {
      proxyPass = "http://localhost:8384";
    };
    "s.sync.localhost".locations."/" = {
      proxyPass = "http://localhost:8385";
    };
  };
  #services.nginx.virtualHosts."localhost".locations = lib.mapAttrs
  #  (name: value: {
  #    proxyPass = "http://localhost:${toString value}";
  #    #return = "308 http://localhost:${toString value}";
  #    #recommendedProxySettings = false;
  #    proxyWebsockets = true;
  #    } // (if name == "/" then {} else {priority = 100;})) linking;
  #services.nginx.virtualHosts."127.0.0.1".locations = lib.mapAttrs
  #  (name: value: { proxyPass = "https://127.0.0.1:${toString value}"; }) linking;

}
