{ config, lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.desktop.launchers.enable = mkEnableOption "launchers" // {
    default = config.my.desktop.hyprland.enable;
  };
  imports = [
    ./rofi.nix
    ./vicinae.nix
  ];
}
