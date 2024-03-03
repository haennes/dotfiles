# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./services/backup.nix
    ];
    services.syncthing-wrapper = {
      enable = true;
    };
    services.syncthing = 
    let
      dev_name = config.services.syncthing-wrapper.dev_name;
    in
    {
      dataDir = "/home/hannses";
      key = config.age.secrets."syncthing_key_${dev_name}".path;
      cert = config.age.secrets."syncthing_cert_${dev_name}".path;
    };

    services.wireguard-wrapper.enable = true;

    hardware.openrazer.enable = true;
    hardware.openrazer. users = ["hannses"];
    networking.hostName = "mainpc"; # Define your hostname.

}
