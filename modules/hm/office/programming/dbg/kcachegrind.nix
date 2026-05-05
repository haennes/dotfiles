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
  options.my.office.programming.dbg.kcachegrind.enable =
    mkEnableOption "GUI to profilers such as Valgrind"
    // {
      default = config.my.office.programming.dbg.enable;
    };
  config = mkIf config.my.office.programming.dbg.kcachegrind.enable {
    home.packages = with pkgs; [ kdePackages.kcachegrind ];
  };
}
