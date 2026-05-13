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
  networking.networkmanager.enable = true;

  services.postgresql.settings.port = lib.mkIf (hports ? postresql) hports.postgresql;

}
