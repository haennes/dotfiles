{ lib, pkgs, favicon, ... }: {
  "geizhals" = {
    urls = [{
      template = "https://geizhals.de";
      params = [
        {
          name = "fs";
          value = "{searchTerms}";
        }
        {
          name = "hloc";
          value = "de";
        }
        {
          name = "hloc";
          value = "at";
        }
      ];
    }];
    definedAliases = [ "<geiz" ];
    icon = favicon "geizhals.de";
  };
}
