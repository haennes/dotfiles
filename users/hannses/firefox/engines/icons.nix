{ updateInterval, favicon, ... }:
{
  "mdi-icons" = {
    urls = [ { template = "https://pictogrammers.com/library/mdi?q={searchTerms}"; } ];
    definedAliases = [
              # keep-sorted start
      "<mdi"
      "<i1"
              # keep-sorted end
    ];
    icon = favicon "pictogrammers.com";
    inherit updateInterval;
  };

  "simpleicons" = {
    urls = [ { template = "https://simpleicons.org/?q={searchTerms}"; } ];
    definedAliases = [
              # keep-sorted start
      "<si"
      "<i2"
              # keep-sorted end
    ];
    icon = favicon "simpleicons.org/images";
    inherit updateInterval;
  };
}
