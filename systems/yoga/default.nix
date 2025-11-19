# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, specialArgs, lib, inputs, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.initrd.luks.devices."luks-25879778-fcba-4dab-9ad7-a929638b13ec".device =
    "/dev/disk/by-uuid/25879778-fcba-4dab-9ad7-a929638b13ec";
  networking.hostName = "yoga"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  services.syncthing-wrapper = { enable = true; };
  services.syncthing = {
    dataDir = "/syncthing";
    #user = "hannses";
  };

  fs-watchers = {
    w.typst = true;
    w.xournalpp = true;
    w.nc-sync = true;
  };
  services.wireguard-wrapper.enable =
    true; # currently wg0 forwarind all traffic is broken
  networking.networkmanager.unmanaged = [ "wg0" ];

  microvmHost.extInterface = "wlp1s0";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.fs-watcher = {
    enable = true;
    user = config.services.syncthing.user;
  };
}
