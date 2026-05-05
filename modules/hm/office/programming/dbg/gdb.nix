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
  options.my.office.programming.dbg.gdb.enable = mkEnableOption "gnu debugger" // {
    default = config.my.office.programming.dbg.enable;
  };
  config = mkIf config.my.office.programming.dbg.gdb.enable {
    home.packages = with pkgs; [ gdb ];
  };
}
