{ updateInterval, ... }:
{
  "Invidious (nerdvpn.de)" = {
    urls = [ { template = "https://invidious.nerdvpn.de/search?q={searchTerms}"; } ];
    icon = "https://docs.invidious.io/images/invidious.png";
    inherit updateInterval;
    definedAliases = [
              # keep-sorted start
      "<yt"
      "<inv"
              # keep-sorted end
    ];
  };

}
