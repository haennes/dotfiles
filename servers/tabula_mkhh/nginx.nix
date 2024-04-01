{lib, config, ...}:{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      # TODO subdomains
      "mkhh.hannses.de" = {
	# disabled because https is used up to vps
        #enableACME = true; 
	#forceSSL = true;
        root = "/var/www/website_mkhh";
      };
    };
  };
}
