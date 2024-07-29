{ updateInterval, ... }: {
  "fdroid" = {
    urls = [{ template = "https://search.f-droid.org/?q={searchTerms}"; }];
    iconUpdateURL =
      "https://f-droid.org/assets/fdroid-logo_bfHl7nsLHOUQxzdU8-rGIhn4bAgl6z7k2mA3fWoCyT4=.png";
    definedAliases = [ "<fdroid" ];
    inherit updateInterval;
  };
}
