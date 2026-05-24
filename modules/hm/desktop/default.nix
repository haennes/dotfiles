{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./ntfyd.nix
    ./gnome.nix
    ./gtk.nix
    ./hyprland.nix
    ./wallpaper.nix
    ./lock.nix
    ./idle.nix
    ./nightlight.nix
    ./launchers
    ./bar.nix
    ./portal.nix
    ./audio.nix
    ./screenshot.nix
    ./monitors.nix
    ./autostart.nix
  ];
  options.my.desktop.enable = mkEnableOption "desktop" // {
    default = osConfig.is_client;
  };
}
