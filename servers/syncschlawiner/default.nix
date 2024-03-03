{ config, pkgs, sshkeys, ... }:
{
  system.stateVersion = "23.11"; 
  imports = [
 ../proxmox.nix
 ./nextcloud.nix
];
  boot.kernel.sysctl = { "fs.inotify.max_user_watches" = 204800;};
  services.syncthing = {
    dataDir = "/data/syncthing";
    user = "nextcloud";
  };
  services.syncthing_wrapper = {
    enable = true;
  };
  
  users.users."nextcloud".uid = 237; #because of how folder was created

  networking.hostName = "syncschlawiner"; # Define your hostname.
  fileSystems."/data" = {
      device = "/dev/disk/by-uuid/c01f7a7e-f5ca-4642-a159-bbc8d86e23b6";
      fsType = "ext4";
  };

  services.wireguard-wrapper.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 24 80 8080 443 ];
  #networking.firewall.allowedUDPPorts = [ 25565 ];


} 
