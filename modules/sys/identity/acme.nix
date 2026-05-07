{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.identity.acme.enable = mkEnableOption "acme" // {
    default = true;
  };
  config = mkIf config.my.identity.acme.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "vegsy5q8@anonaddy.me";
    };
  };
}
