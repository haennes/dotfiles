{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.desktop.audio.enable = mkEnableOption "desktop audio" // {
    default = config.my.desktop.enable;
  };
  config = mkIf config.my.desktop.audio.enable {
    home.packages = with pkgs; [
      playerctl
      pavucontrol
    ];
  };
}
