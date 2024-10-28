# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ specialArgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./zfs.nix
    #./services/backup.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  microvm.vms = {
    tabula = {
      inherit specialArgs;
      config = import ../../servers/tabula;
      pkgs = null;
    };
    fons = {
      inherit specialArgs;
      config = import ../../servers/fons;
      pkgs = null;
    };
    historia = {
      inherit specialArgs;
      config = import ../../servers/historia;
      pkgs = null;
    };
  };
  #services.syncthing_wrapper = { enable = true; };
  #services.syncthing = {
  #  dataDir = "/data/syncthing";
  #  user = "hannses";
  #};

  microvmHost.extInterface = "enp37s0";

  networking.networkmanager.unmanaged = [ "wg0" ];
  networking.networkmanager.enable = true;
  services.wireguard-wrapper.enable = true;

  networking.hostName = "deus"; # Define your hostname.

}
