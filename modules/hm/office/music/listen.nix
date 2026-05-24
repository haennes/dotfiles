{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
in
{
  options.my.office.music.listen = {
    enable = mkEnableOption "listening to music software" // {
      default = config.my.office.music.enable;
    };
    spotify = {
      enable = mkEnableOption "spotify" // {
        default = config.my.office.music.listen.enable;
      };
    };
  };
  config = mkIf config.my.office.music.listen.enable {
    home.packages = with pkgs; [
      shortwave
    ];
    my.desktop.autostart.autostart = mkIf config.my.office.music.listen.spotify.enable [
      {
        desktop = "special:music";
        cmd = "${pkgs.firefox}/bin/firefox -P spotify";
      }
    ];
    programs.firefox.profiles.spotify = mkIf config.my.office.music.listen.spotify.enable {
      isDefault = false;
      id = 2;
      settings = (import ../browsers/firefox/settings.nix { }).all // {
        "browser.startup.page" = 1;
        "browser.startup.homepage" = "open.spotify.com";
      };
    };
  };
}
