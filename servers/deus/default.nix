# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # keep-sorted start
    ./vms.nix
    ./zfs.nix
    inputs.esw-machines.nixosModules.default
    #./kasm.nix
    # ./hydra.nix
    #./services/backup.nix
    # keep-sorted end
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.getty.autologinUser = "root";

  services.syncthing-wrapper = {
    enable = true;
    paths.system.pathFunc =
      { folderID, physicalPath, ... }:
      let
        cfg = config.services.syncthing-wrapper;
        cfg_s = config.services.syncthing;
        optionalUser = cfg.idToOptionalUserName folderID;
        middle = lib.optionalString (optionalUser != null) "/${optionalUser}";
        legacyID = cfg_s.settings.folders.${folderID}.id;
      in
      "${physicalPath}${middle}/${legacyID}";
  };
  services.syncthing = {
    dataDir = "/data/syncthing";
    # user = "hannses";
  };

  microvmHost.extInterface = "enp37s0";
  networking.useNetworkd = true;

  #networking.networkmanager.unmanaged = [ "wg0" ];
  #networking.networkmanager.enable = true;
  services.wireguard-wrapper.enable = true;

  networking.hostName = "deus"; # Define your hostname.
  services.esw-machines = {
    enable = true;
    port = config.ports.ports.curr_ports.esw;
    domain = "0.0.0.0";
    user = config.services.syncthing.user;
    dataFilePath = "${config.services.syncthing.settings.folders."esw-machine__esw-machines".path}/esw";
  };
  networking.firewall.allowedTCPPorts = [ config.ports.ports.curr_ports.esw ];

}
