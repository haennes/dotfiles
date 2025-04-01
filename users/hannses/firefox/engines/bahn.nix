{ updateInterval, favicon, ... }: {
  "bahnhof.de" = {
    urls = [{ template = "https://www.bahnhof.de/suche?term={searchTerms}"; }];
    icon = favicon "www.bahnhof.de";
    definedAliases = [ "<bahnhof" "<hbf" ];
    inherit updateInterval;
  };
}
