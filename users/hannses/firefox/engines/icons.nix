{ updateInterval, favicon, ... }: {
  "mdi-icons" = {
    urls =
      [{ template = "https://pictogrammers.com/library/mdi?q={searchTerms}"; }];
    definedAliases = [ "<mdi" "<i1" ];
    icon = favicon "pictogrammers.com";
    inherit updateInterval;
  };

  "simpleicons" = {
    urls = [{ template = "https://simpleicons.org/?q={searchTerms}"; }];
    definedAliases = [ "<si" "<i2" ];
    icon = favicon "simpleicons.org/images";
    inherit updateInterval;
  };
}
