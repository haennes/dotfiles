{ updateInterval, favicon, ... }: {
  "addy.io" = {
    urls = [{
      template =
        "https://app.addy.io/aliases?shared_domain=true&active=true&search={searchTerms}";
    }];
    definedAliases = [ "<addy" "<anon" ];
    iconUpdateURL = favicon "addy.io";
    inherit updateInterval;
  };
}
