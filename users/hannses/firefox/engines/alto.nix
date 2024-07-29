{ updateInterval, ... }: {
  "alternativeto.net" = {
    urls = [{
      template = "https://alternativeto.net/browse/search/?q={searchTerms}";
    }];
    iconUpdateURL =
      "https://cdn-1.webcatalog.io/catalog/alternativeto/alternativeto-icon-filled.png";
    inherit updateInterval;
    definedAliases = [ "<alto" ];
  };
}
