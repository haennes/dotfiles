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
      grimblast
      slurp
    ];
  };
}
