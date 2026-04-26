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
  options.my.utils.tuis.bluetooth.enable = mkEnableOption "bluetooth" // {
    default = config.my.utils.tuis.enable;
  };
  config = mkIf config.my.utils.tuis.bluetooth.enable {
    environment.systemPackages = with pkgs; [
      bluetuith
    ];
  };
}
