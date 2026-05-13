{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.desktop.hyprland.enable = mkEnableOption "hyprland" // {
    default = true;
  };
  config = mkIf config.my.desktop.hyprland.enable {
    programs.hyprland.enable = true;
  };
}
