{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.hardware.wifi.enable = mkEnableOption "fwupd" // {
    default = config.is_client;
  };
  config = mkIf config.my.hardware.wifi.enable {
    networking.networkmanager.enable = true;
  };
}
