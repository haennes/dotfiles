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
  services.postgresql.settings.port = lib.mkIf (hports ? postresql) hports.postgresql;

}
