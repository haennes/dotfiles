{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.rss.enable = mkEnableOption "newsboat rss" // {
    default = config.my.office.enable;
  };
  config = mkIf config.my.office.rss.enable {
    programs.newsboat = {
      enable = true;
      autoReload = true;
      extraConfig = ''
        urls-source "freshrss"
        freshrss-url "http://rss.localhost/api/greader.php"
        freshrss-login "hannses"
        freshrss-password "secret2"
      '';
    };
  };
}
