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
  options.my.office.modelling.prusa-slicer.enable = mkEnableOption "prusa-slicer" // {
    default = config.my.office.modelling.enable;
  };
  config = mkIf config.my.office.modelling.prusa-slicer.enable {
    environment.systemPackages = with pkgs; [
      prusa-slicer
    ];
  };
}
