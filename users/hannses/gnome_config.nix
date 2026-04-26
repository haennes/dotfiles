{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.my.desktop.gnome.enable {
    home.packages = with pkgs; [
      gnomeExtensions.dash-to-dock
      gnomeExtensions.user-themes
    ];
    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = [
          "terminate:ctrl_alt_bksp"
          "lv3:ralt_switch"
          "caps:escape"
        ];
      };
      "org/gnome/shell" = {
        favorite-apps = [
          "firefox.desktop"
          "codium.desktop"
          "zellij.desktop"
        ];
        enabled-extensions = [
          "gSnap@micahosborne"
        ];
      };
    };
  };
}
