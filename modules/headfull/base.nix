{ lib, config, pkgs, ... }:
let hports = config.ports.ports.curr_ports;

in {
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;

  boot.kernelPackages =
    if (lib.any (v: v.fsType == "zfs") (lib.attrValues config.fileSystems)) then
      config.boot.zfs.package.latestCompatibleLinuxPackages
    else
      pkgs.linuxPackages_latest;
  services.logind.powerKey = "suspend";

  services.udisks2.enable = true;

  services.postgresql.settings.port =
    lib.mkIf (hports ? postresql) hports.postgresql;

}
