{ updateInterval, ... }: {
  "elo" = {
    urls = [{
      template =
        "https://elearning.oth-regensburg.de/course/view.php?id={searchTerms}";
    }];
    icon =
      "https://elearning.oth-regensburg.de/pluginfile.php/1/theme_boost_union/favicon/64x64/1767780107/ELO_favicon-02.png";
    inherit updateInterval;
    definedAliases = [ "<eloid" ];
  };
}
