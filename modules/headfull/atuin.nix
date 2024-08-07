{...}:{
  services.atuin = {
    enable = true;
    database.createLocally = true;
    openRegistration = true;
    openFirewall = false;
    host = "127.0.0.1";
  };

  services.nginx.virtualHosts."atuin.localhost"= {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8888";
    };
  };
}
