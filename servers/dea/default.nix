# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ specialArgs, lib, ... }:
let hostname = "tabula_1";
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./zfs.nix
    ./taskchampion.nix
    #./kasm.nix
    ./hydra.nix
    ./ipfs.nix
    ./nextcloud.nix
    ./vms.nix
    #./services/backup.nix
  ];

  lix.enable = false;
  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sdb";
    useOSProber = true;
  };
  services.nix-serve.enable = true; # is configured in modules/all/nix-serve

  services.getty.autologinUser = "root";

  #services.syncthing_wrapper = { enable = true; };
  #services.syncthing = {
  #  dataDir = "/data/syncthing";
  #  user = "hannses";
  #};

  microvmHost.extInterface = "enp0s31f6";
  networking.useNetworkd = true;

  #networking.networkmanager.unmanaged = [ "wg0" ];
  #networking.networkmanager.enable = true;
  services.wireguard-wrapper.enable = true;

  networking.hostName = "dea"; # Define your hostname.

}
