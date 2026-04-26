{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.desktop.monitors.enable = mkEnableOption "monitors" // {
    default = config.my.desktop.hyprland.enable;
  };
  config = mkIf config.my.desktop.monitors.enable {
    home.packages = with pkgs; [
      wlr-randr
      wdisplays # gui display positioning
    ];
  };
}
