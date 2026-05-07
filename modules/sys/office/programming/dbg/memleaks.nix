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
  options.my.office.programming.dbg.memleaks.enable =
    mkEnableOption "mem leak debugging using valgrind"
    // {
      default = config.my.office.programming.dbg.enable;
    };
  config = mkIf config.my.office.programming.dbg.memleaks.enable {
    environment.systemPackages = with pkgs; [ valgrind ];
  };
}
