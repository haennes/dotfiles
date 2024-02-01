{ config, pkgs, sshkeys, ... }:
{
  system.stateVersion = "23.11"; 
  imports = [
   ../proxmox.nix
 #./nextcloud.nix
 #../../modules/syncthing.nix
];
  services.onlyoffice.enable = true;

  networking.hostName = "grapheum"; # Define your hostname.
  networking.firewall.allowedTCPPorts = [ 22 8000 ];
} 
