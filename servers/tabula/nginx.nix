{ ... }: {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "hannses.de" = {
        # https disabled because it is used up to vps
        root = "/persist/website";
      };
    };
  };

  networking.firewall = { allowedTCPPorts = [ 80 ]; };

}
