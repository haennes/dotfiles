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
  options.my.office.programming.cmc.enable = mkEnableOption "compile construction" // {
    default = config.my.office.programming.enable;
  };
  config = mkIf config.my.office.programming.cmc.enable {
    home.packages = with pkgs; [
      bison
      flex
    ];
  };
}
