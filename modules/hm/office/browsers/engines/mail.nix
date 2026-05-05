{ updateInterval, favicon, ... }:
{
  "addy.io" = {
    urls = [
      {
        template = "https://app.addy.io/aliases?shared_domain=true&active=true&search={searchTerms}";
      }
    ];
    definedAliases = [
      # keep-sorted start sticky_comments=no block=yes
      "<addy"
      "<anon"
      # keep-sorted end
    ];
    icon = favicon "addy.io";
    inherit updateInterval;
  };
}
