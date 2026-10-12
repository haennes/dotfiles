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
  options.my.desktop.sway.enable = mkEnableOption "swayfx" // {
    default = config.is_client;
  };
  config = mkIf config.my.desktop.sway.enable {
    security.polkit.enable = true;
  };
}
