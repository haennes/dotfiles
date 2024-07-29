{ favicon, updateInterval, ... }: {
  "ecosia" = {
    urls = [{
      template = "https://www.ecosia.org/search?method=index&q={searchTerms}";
    }];
    iconUpdateURL = favicon "www.ecosia.org";
    inherit updateInterval;
  };

  "Startpage" = {
    urls = [{
      template = "https://www.startpage.com/sp/search";
      params = [
        {
          name = "query";
          value = "{searchTerms}";
        }
        {
          name = "cat";
          value = "web";
        }
      ];
    }];
    definedAliases = [ "<sp" ];
    iconUpdateURL =
      "https://www.startpage.com/sp/cdn/images/startpage-logo-gradient-dark.svg";
    inherit updateInterval;
  };

  "DuckDuckGo" = {
    urls = [{
      template = "https://duckduckgo.com";
      params = [
        {
          name = "t";
          value = "ffab";
        }
        {
          name = "ia";
          value = "web";
        }
        {
          name = "q";
          value = "{searchTerms}";
        }
      ];
    }];
    iconUpdateURL =
      "https://duckduckgo.com/duckduckgo-help-pages/logo.v109.svg";
    inherit updateInterval;
    definedAliases = [ "<ddg" ];
  };

}
