{ updateInterval, favicon, ... }: {
  "thingiverse" = {
    urls = [{
      template = "https://www.thingiverse.com/search?q={searchTerms}&page=1";
    }];
    icon = favicon "www.thingiverse.com";
    inherit updateInterval;
    definedAliases = [ "<thing" ];
  };
}
