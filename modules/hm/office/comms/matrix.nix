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
  options.my.office.comms.matrix.enable = mkEnableOption "matrix messenger" // {
    default = config.my.office.comms.enable;
  };
  config = mkIf config.my.office.comms.matrix.enable {
    home.packages = with pkgs; [
      element-desktop
    ];
  };
}
