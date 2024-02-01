{lib, config, ips, ...}:{
  security.acme = {
    acceptTerms = true;
    defaults.email = "vegsy5q8@anonaddy.me";
    certs = {
      "hannses.de" = {inheritDefaults = true;};
      "cloud.hannses.de" = {inheritDefaults = true;};
    };
  };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      # TODO subdomains
      "hannses.de" = {
        enableACME = true;
	forceSSL = true;
        #root = "/var/www/website";
	locations."/" = {
	  proxyPass = "http://${ips.tabula.wg0}";
	  proxyWebsockets = true; # needed if you need to use WebSocket
	  extraConfig =
          # required when the target is also TLS server with multiple hosts
          "proxy_ssl_server_name on;" + # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;"
          ;#"/kehl" = {
	  #  root = "/var/www/website/kehl";
	  #  basicAuthFile = config.age.secrets.kehl_login.path;
	  #};
	  #"/cool" = {
	  #  root = "/var/www/website/main";
	  #};
	};
      };
      "cloud.hannses.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://${ips.syncschlawiner.wg0}";
          proxyWebsockets = true; # needed if you need to use WebSocket
	  extraConfig =
          # required when the target is also TLS server with multiple hosts
          "proxy_ssl_server_name on;" + # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;"
          ;
        };
      };
    };
  };
  age.secrets.kehl_login = {
    file = ../../secrets/kehl_login.age;
    owner = "nginx";
  };
}
