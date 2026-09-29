{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  actions = import ../../desktop/wm/actions.nix {
    inherit config lib pkgs;
  };
  bindle = actions.lockedRepeat;
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
    my.desktop = let
        key = "i";
      in mkIf config.my.office.music.listen.spotify.enable {
      autostart.autostart."special:music" = {
        tabbed = [ "${pkgs.firefox}/bin/firefox -P spotify" ];
      };
      wm.common.specialWorkspaces = {
        music = key;
      };
      wm.common.submaps.music = {
        entry = "mod+${key}";
        binds = let
          plrctla = a: bindle (actions.exec "playerctl ${a}");
          next = plrctla "next";
          prev = plrctla "previous";
          pause = plrctla "play-pause";
        in {
          "o" = next;
          "n" = next;
          "u" = prev;
          "p" = prev;
          "space" = pause;
          "g" = actions.specialToggle "music";
          "escape" = actions.reset;
          "return" = actions.reset;
        };
      };

    };
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
