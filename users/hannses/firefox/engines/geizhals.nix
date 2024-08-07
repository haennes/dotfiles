{ lib, favicon, pkgs, ... }:let
  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg" ;
in
lib.mapAttrs (_name: value: if value ? icon then value else value // {inherit icon;})
{
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
  };

}
