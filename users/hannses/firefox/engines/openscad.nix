{ updateInterval, ... }: {
  "BOSL" = {
    urls = [{
      template =
        "https://github.com/search?q=repo%3ABelfrySCAD%2FBOSL2+{searchTerms}&type=wikis";
    }];
    icon =
      "https://github.com/BelfrySCAD/BOSL2/blob/master/images/BOSL2logo.png?raw=true";
    definedAliases = [ "<bosl" ];
    inherit updateInterval;
  };
}
