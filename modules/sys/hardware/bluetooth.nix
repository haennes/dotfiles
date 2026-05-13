{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.hardware.bluetooth.enable = mkEnableOption "fwupd" // {
    default = config.is_client;
  };
  config = mkIf config.my.hardware.bluetooth.enable {
    hardware.bluetooth.enable = true;
  };
}
