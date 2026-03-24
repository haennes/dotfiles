{ updateInterval, ... }:
{
  "Invidious (nerdvpn.de)" = {
    urls = [ { template = "https://invidious.nerdvpn.de/search?q={searchTerms}"; } ];
    icon = "https://docs.invidious.io/images/invidious.png";
    inherit updateInterval;
    definedAliases = [
      # keep-sorted start
      "<inv"
      "<yt"
      # keep-sorted end
    ];
  };

}
