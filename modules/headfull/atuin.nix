{config, lib, hports, ...}:{
  services.atuin = {
    enable = true;
    database.createLocally = true;
    openRegistration = false;
    openFirewall = false;
    host = "127.0.0.1";
    port = hports.atuin;
  };

  services.nginx.virtualHosts."atuin.localhost"= lib.mkIf config.services.atuin.enable {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.atuin.port}";
    };
  };
}