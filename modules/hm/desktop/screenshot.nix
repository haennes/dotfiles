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
  options.my.desktop.screenshot.enable = mkEnableOption "screenshot" // {
    default = config.my.desktop.enable;
  };
  config = mkIf config.my.desktop.screenshot.enable {
    home.packages = with pkgs; [
      grim
      slurp
    ] ++ lib.optionals config.my.desktop.hyprland.enable [ grimblast ]
      ++ lib.optionals config.my.desktop.sway.enable [ sway-contrib.grimshot ];
  };
}
