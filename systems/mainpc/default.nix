# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	../../modules/syncthing.nix
      #./services/backup.nix
      #../common/headfull.nix
    ];
     services.syncthing_wrap = {
      enable = true;
      dataDir = "/home/hannses";
    };
   
    services.wireguard-wrapper.enable = true;

    hardware.openrazer.enable = true;
    hardware.openrazer. users = ["hannses"];
    networking.hostName = "mainpc"; # Define your hostname.

}
