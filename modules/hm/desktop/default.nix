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
  ];
  options.my.desktop.enable = mkEnableOption "desktop" // {
    default = osConfig.is_client;
  };
}
