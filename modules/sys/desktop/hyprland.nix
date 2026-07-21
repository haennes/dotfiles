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
    default = config.is_client;
  };
  config = mkIf config.my.desktop.hyprland.enable {
    programs.hyprland.enable = true;
  };
}
