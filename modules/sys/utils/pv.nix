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
  options.my.utils.pv.enable = mkEnableOption "pv" // {
    default = true;
  };
  config = mkIf config.my.utils.pv.enable {
    environment.systemPackages = with pkgs; [
      pv
    ];
  };
}
