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
      "<typs"
      "<typsym"
      "<tys"
      "<ty"
      "<typ"
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
      "<type"
      "<typemoji"
      "<tye"
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
