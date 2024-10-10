{ favicon, updateInterval, ... }: {
  "cppreference" = {
    urls = [{
      template =
        "https://duckduckgo.com/?sites=cppreference.com&q={searchTerms}";
    }];
    iconUpdateURL = favicon "cppreference.com";
    definedAliases = [ "<cppa" ];
    inherit updateInterval;
  };

  "cplusplus" = {
    urls = [{ template = "https://cplusplus.com/search.do?q={searchTerms}"; }];
    iconUpdateURL = favicon "cplusplus.com";
    definedAliases = [ "<cppb" ];
    inherit updateInterval;
  };
}
