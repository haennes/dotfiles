{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.programming.dbg.enable = mkEnableOption "debugging" // {
    default = config.my.office.programming.enable;
  };
  imports = [
    ./gdb.nix
  ];
}
