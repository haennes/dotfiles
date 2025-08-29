# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ specialArgs, lib, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./zfs.nix
    ./vms.nix
    #./kasm.nix
    # ./hydra.nix
    #./services/backup.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.getty.autologinUser = "root";

  #services.syncthing_wrapper = { enable = true; };
  #services.syncthing = {
  #  dataDir = "/data/syncthing";
  #  user = "hannses";
  #};

  microvmHost.extInterface = "enp37s0";
  networking.useNetworkd = true;

  #networking.networkmanager.unmanaged = [ "wg0" ];
  #networking.networkmanager.enable = true;
  services.wireguard-wrapper.enable = true;

  networking.hostName = "deus"; # Define your hostname.

}
