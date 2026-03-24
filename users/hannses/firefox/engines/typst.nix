{ updateInterval, favicon, ... }:
{
  "typst-sym" = {
    urls = [
      {
        template = "https://typst.app/docs/reference/symbols/sym?query={searchTerms}";
      }
    ];
    definedAliases = [
      # keep-sorted start
      "<ty"
      "<typ"
      "<typs"
      "<typsym"
      "<tys"
      # keep-sorted end
    ];
    icon = favicon "typst.app";
    inherit updateInterval;
  };

  "typst-emoji" = {
    urls = [
      {
        template = "https://typst.app/docs/reference/symbols/emoji?query={searchTerms}";
      }
    ];
    definedAliases = [
      # keep-sorted start
      "<tye"
      "<type"
      "<typemoji"
      # keep-sorted end
    ];
    icon = favicon "typst.app";
    inherit updateInterval;
  };

  "typst-universe" = {
    urls = [ { template = "https://typst.app/universe/search?q={searchTerms}"; } ];
    definedAliases = [
      # keep-sorted start
      "<typu"
      "<typuniverse"
      "<tyu"
      # keep-sorted end
    ];
    icon = favicon "typst.app";
    inherit updateInterval;
  };

}
