# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./services/backup.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.syncthing_wrapper = { enable = true; };
  services.syncthing = {
    dataDir = "/home/hannses";
    user = "hannses";
  };
  services.wireguard-wrapper.enable = true;

  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ "hannses" ];
  networking.hostName = "mainpc"; # Define your hostname.

}
