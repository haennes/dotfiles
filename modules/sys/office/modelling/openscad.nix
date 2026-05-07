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
  options.my.office.modelling.openscad.enable = mkEnableOption "openscad" // {
    default = config.my.office.modelling.enable;
  };
  config = mkIf config.my.office.modelling.openscad.enable {
    environment.systemPackages = with pkgs; [
      openscad
    ];
  };
}
