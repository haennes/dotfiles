{ips, ...}: with ips;{
  networking.domains = {
    enable = true;
    baseDomains = {
      "hannses.de" = {
        a.data = welt.ens3;
	#TODO aaaa
      };
    };
    subDomains = {
      "cloud.hannses.de" = {};
    };
  };
}
