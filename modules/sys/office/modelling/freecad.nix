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
  options.my.office.modelling.freecad.enable = mkEnableOption "freecad" // {
    default = config.my.office.modelling.enable;
  };
  config = mkIf config.my.office.modelling.freecad.enable {
    environment.systemPackages = with pkgs; [
      freecad
    ];
  };
}
