{ updateInterval, ... }: {
  "Invidious (nerdvpn.de)" = {
    urls =
      [{ template = "https://invidious.nerdvpn.de/search?q={searchTerms}"; }];
    icon = "https://docs.invidious.io/images/invidious.png";
    inherit updateInterval;
    definedAliases = [ "<yt" "<inv" ];
  };

}
