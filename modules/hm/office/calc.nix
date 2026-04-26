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
  options.my.office.calc.enable = mkEnableOption "calculators" // {
    default = config.my.office.enable;
  };
  config = mkIf config.my.office.calc.enable {
    home.packages = with pkgs; [
      fend
    ];
  };
}
