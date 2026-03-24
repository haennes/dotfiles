{ updateInterval, favicon, ... }:
{
  "addy.io" = {
    urls = [
      {
        template = "https://app.addy.io/aliases?shared_domain=true&active=true&search={searchTerms}";
      }
    ];
    definedAliases = [
      # keep-sorted start
      "<addy"
      "<anon"
      # keep-sorted end
    ];
    icon = favicon "addy.io";
    inherit updateInterval;
  };
}
