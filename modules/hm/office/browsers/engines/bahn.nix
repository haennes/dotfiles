{ updateInterval, favicon, ... }:
{
  "bahnhof.de" = {
    urls = [ { template = "https://www.bahnhof.de/suche?term={searchTerms}"; } ];
    icon = favicon "www.bahnhof.de";
    definedAliases = [
      # keep-sorted start sticky_comments=no block=yes
      "<bahnhof"
      "<hbf"
      # keep-sorted end
    ];
    inherit updateInterval;
  };
}
