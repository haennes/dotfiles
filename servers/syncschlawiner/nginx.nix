{lib, ...}:{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      # TODO subdomains
      "192.168.1.5" = {
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
