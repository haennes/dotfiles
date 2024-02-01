{lib, config, ...}:{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      # TODO subdomains
      "hannses.de" = {
        #enableACME = true;
	#forceSSL = true;
        root = "/var/www/website";
	locations = {
	  "/kehl" = {
	    basicAuthFile = config.age.secrets.kehl_login.path;
	  };
	};
      };
    };
  };
  age.secrets.kehl_login = {
    file = ../../secrets/kehl_login.age;
    owner = "nginx";
  };
}
