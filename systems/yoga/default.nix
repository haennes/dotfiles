# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, specialArgs, lib, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-25879778-fcba-4dab-9ad7-a929638b13ec".device =
    "/dev/disk/by-uuid/25879778-fcba-4dab-9ad7-a929638b13ec";
  networking.hostName = "yoga"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  services.syncthing_wrapper = {
    enable = true;
    ensureDirsExistsDefault = "setfacl";
  };
  services.syncthing = {
    dataDir = "/home";
    user = "hannses";
  };
  services.wireguard-wrapper.enable =
    true; # currently wg0 forwarind all traffic is broken
  networking.networkmanager.unmanaged = [ "wg0" ];

  microvmHost.extInterface = "wlp1s0";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  microvm.vms = lib.my.mkVMS {
    names = [ ];
    inherit specialArgs;
  };
}
