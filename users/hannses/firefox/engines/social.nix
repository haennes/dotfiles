{ updateInterval, ... }:
{
  "Invidious (nerdvpn.de)" = {
    urls = [ { template = "https://invidious.nerdvpn.de/search?q={searchTerms}"; } ];
    icon = "https://docs.invidious.io/images/invidious.png";
    inherit updateInterval;
    definedAliases = [
      # keep-sorted start sticky_comments=no block=yes
      "<inv"
      "<yt"
      # keep-sorted end
    ];
  };

}
