{ updateInterval, favicon, ... }: {
  "typst-sym" = {
    urls = [{
      template =
        "https://typst.app/docs/reference/symbols/sym?query={searchTerms}";
    }];
    definedAliases = [ "<typs" "<typsym" "<tys" "<ty" "<typ" ];
    icon = favicon "typst.app";
    inherit updateInterval;
  };

  "typst-emoji" = {
    urls = [{
      template =
        "https://typst.app/docs/reference/symbols/emoji?query={searchTerms}";
    }];
    definedAliases = [ "<type" "<typemoji" "<tye" ];
    icon = favicon "typst.app";
    inherit updateInterval;
  };

  "typst-universe" = {
    urls =
      [{ template = "https://typst.app/universe/search?q={searchTerms}"; }];
    definedAliases = [ "<typu" "<typuniverse" "<tyu" ];
    icon = favicon "typst.app";
    inherit updateInterval;
  };

}
