{ config, ... }: {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "hannses.de" = {
        # https disabled because it is used up to vps
        root =
          "${config.services.syncthing.settings.folders.hannses__website.path}";
      };
    };
  };

  networking.firewall = { allowedTCPPorts = [ 80 ]; };

}
