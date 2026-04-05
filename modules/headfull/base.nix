{
  lib,
  config,
  pkgs,
  ...
}:
let
  hports = config.ports.ports.curr_ports;

in
{
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;

  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandleLidSwitch = "suspend";
  };

  services.udisks2.enable = true;

  services.postgresql.settings.port = lib.mkIf (hports ? postresql) hports.postgresql;

}
