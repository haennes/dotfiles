# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ specialArgs, lib, ... }:
let hostname = "tabula_1";
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./zfs.nix
    #./kasm.nix
    ./hydra.nix
    #./services/backup.nix
  ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sdb";
    useOSProber = true;
  };

  #microvm.vms = {
  #  tabula_1 = {
  #    inherit specialArgs;
  #    config = ../../vms/instances/tabula_1.nix;
  #    pkgs = null;
  #  };
  #};

  #age.secrets."sshkeys/${hostname}/age_key" = {
  #  path = "/persistant/microvms/${hostname}/age_key";
  #  file = ../../secrets/sshkeys/${hostname}/age_key.age;
  #  symlink = false;
  #};
  #age.secrets."sshkeys/${hostname}/ssh_host_ed25519_key" = {
  #  path = "/persistant/microvms/${hostname}/ssh/ssh_host_ed25519_key";
  #  file = ../../secrets/sshkeys/${hostname}/ssh_host_ed25519_key.age;
  #  symlink = false;
  #};
  #age.secrets."sshkeys/${hostname}/ssh_host_rsa_key" = {
  #  path = "/persistant/microvms/${hostname}/ssh/ssh_host_rsa_key";
  #  file = ../../secrets/sshkeys/${hostname}/ssh_host_rsa_key.age;
  #  symlink = false;
  #};

  #microvm.vms = lib.my.mkVMS {
  #  names = [
  #    "tabula"
  #    "fons"
  #    "historia"
  #    "minerva"
  #    "vertumnus"
  #    "concordia"
  #    "proserpina"
  #  ];
  #  inherit specialArgs;
  #};
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
#//
#(lib.my.recursiveMerge (map (vm: {
#  microvm.vms = {
#    tabula_1 = {
#      inherit specialArgs;
#      config = import ../../vms/instances/tabula_1.nix;
#      pkgs = null;
#    };
#  };
#
#  age.secrets."sshkeys/${hostname}/age_key" = {
#    path = "/persistant/microvms/${hostname}/age_key";
#    file = ../../secrets/sshkeys/${hostname}/age_key.age;
#    symlink = false;
#  };
#  age.secrets."sshkeys/${hostname}/ssh_host_ed25519_key" = {
#    path = "/persistant/microvms/${hostname}/ssh/ssh_host_ed25519_key";
#    file = ../../secrets/sshkeys/${hostname}/ssh_host_ed25519_key.age;
#    symlink = false;
#  };
#  age.secrets."sshkeys/${hostname}/ssh_host_rsa_key" = {
#    path = "/persistant/microvms/${hostname}/ssh/ssh_host_rsa_key";
#    file = ../../secrets/sshkeys/${hostname}/ssh_host_rsa_key.age;
#    symlink = false;
#  };
#})))
