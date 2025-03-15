# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, specialArgs, lib, inputs, pkgs, ... }:
let
  hostname = "tabula_3";
  hostname_2 = "tabula_1";
in {
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

  microvm.vms = {
    tabula_3 = {
      inherit specialArgs;
      config = ../../vms/instances/tabula_3.nix;
      pkgs = null;
    };
    tabula_1 = {
      inherit specialArgs;
      config = ../../vms/instances/tabula_1.nix;
      pkgs = null;
    };
  };

  age.secrets."sshkeys/${hostname}/age_key" = {
    path = "/persistant/microvms/${hostname}/age_key";
    file = ../../secrets/sshkeys/${hostname}/age_key.age;
    symlink = false;
  };
  age.secrets."sshkeys/${hostname}/ssh_host_ed25519_key" = {
    path = "/persistant/microvms/${hostname}/ssh/ssh_host_ed25519_key";
    file = ../../secrets/sshkeys/${hostname}/ssh_host_ed25519_key.age;
    symlink = false;
  };
  age.secrets."sshkeys/${hostname}/ssh_host_rsa_key" = {
    path = "/persistant/microvms/${hostname}/ssh/ssh_host_rsa_key";
    file = ../../secrets/sshkeys/${hostname}/ssh_host_rsa_key.age;
    symlink = false;
  };
  age.secrets."sshkeys/${hostname_2}/age_key" = {
    path = "/persistant/microvms/${hostname_2}/age_key";
    file = ../../secrets/sshkeys/${hostname_2}/age_key.age;
    symlink = false;
  };
  age.secrets."sshkeys/${hostname_2}/ssh_host_ed25519_key" = {
    path = "/persistant/microvms/${hostname_2}/ssh/ssh_host_ed25519_key";
    file = ../../secrets/sshkeys/${hostname_2}/ssh_host_ed25519_key.age;
    symlink = false;
  };
  age.secrets."sshkeys/${hostname_2}/ssh_host_rsa_key" = {
    path = "/persistant/microvms/${hostname_2}/ssh/ssh_host_rsa_key";
    file = ../../secrets/sshkeys/${hostname_2}/ssh_host_rsa_key.age;
    symlink = false;
  };
}
