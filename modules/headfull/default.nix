{ config, lib, ... }:
let hports = config.ports.ports.curr_ports;
in {
  imports = [
    ./adb.nix # uncomment if needed
    ./base.nix
    ./pkgs.nix
    ./minecraft
    ./tasks.nix
    ./homepage-dashboard.nix
    ./local_nginx.nix
    ./fortivpn.nix
    ./power.nix
    #./virtualization.nix # dont build virtualbox
  ];
  services.postgresql.settings.port =
    lib.mkIf (hports ? postresql) hports.postgresql;

}
