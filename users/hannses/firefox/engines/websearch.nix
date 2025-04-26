{ favicon, updateInterval, ... }: {
  "ecosia" = {
    urls = [{
      template = "https://www.ecosia.org/search?method=index&q={searchTerms}";
    }];
    icon = favicon "www.ecosia.org";
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
    icon =
      "https://www.startpage.com/sp/cdn/images/startpage-logo-gradient-dark.svg";
    inherit updateInterval;
  };

  "ddg" = {
    name = "DuckDuckGo";
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
    icon = "https://duckduckgo.com/duckduckgo-help-pages/logo.v109.svg";
    inherit updateInterval;
    definedAliases = [ "<ddg" ];
  };

}
