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
  options.my.office.modelling.kicad.enable = mkEnableOption "kicad" // {
    default = false;
  };
  config = mkIf config.my.office.modelling.kicad.enable {
    environment.systemPackages = with pkgs; [
      kicad # cad for pcbs
    ];
  };
}
