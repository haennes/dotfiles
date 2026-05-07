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
  options.my.office.programming.lang.c.enable = mkEnableOption "c" // {
    default = config.my.office.programming.lang.enable;
  };
  config = mkIf config.my.office.programming.lang.c.enable {
    environment.systemPackages = with pkgs; [
      gcc # c compiler
    ];
  };
}
