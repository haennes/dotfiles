{ config, pkgs, sshkeys, ... }: {
  system.stateVersion = "23.11";

  imports = [ ../proxmox.nix ];

  networking.hostName = "porta"; # Define your hostname.

  services.wireguard-wrapper.enable = true;

}
