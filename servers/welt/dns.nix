{ config, ... }: {
  networking.domains = {
    enable = true;
    baseDomains = {
      "hannses.de" = {
        a.data = config.ips.ips.ips.default.welt.ens3;
        #TODO aaaa
      };
    };
    subDomains = { "cloud.hannses.de" = { }; };
  };
}
