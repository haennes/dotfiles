{ updateInterval, favicon, ... }: {
  "thingiverse" = {
    urls = [{
      template = "https://www.thingiverse.com/search?q={searchTerms}&page=1";
    }];
    iconUpdateURL = favicon "www.thingiverse.com";
    inherit updateInterval;
    definedAliases = [ "<thing" ];
  };
}
