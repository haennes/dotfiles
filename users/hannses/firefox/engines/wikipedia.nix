{ updateInterval, ... }: {
  "Wikipedia DE" = {
    urls = [{ template = "https://de.wikipedia.org/wiki/{searchTerms}"; }];
    iconUpdateURL =
      "https://upload.wikimedia.org/wikipedia/commons/5/5a/Wikipedia%27s_W.svg";
    inherit updateInterval;
    definedAliases = [ "<wd" ];
  };

  "Wikipedia EN" = {
    urls = [{ template = "https://en.wikipedia.org/wiki/{searchTerms}"; }];
    iconUpdateURL =
      "https://upload.wikimedia.org/wikipedia/commons/5/5a/Wikipedia%27s_W.svg";
    inherit updateInterval;
    definedAliases = [ "<we" ];
  };

}
