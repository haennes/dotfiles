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
  options.my.office.gaming.wine.enable = mkEnableOption "steam" // {
    default = config.my.office.gaming.enable;
  };
  config = mkIf config.my.office.gaming.wine.enable {
    environment.systemPackages = with pkgs; [
      wineWow64Packages.waylandFull
    ];
  };
}
