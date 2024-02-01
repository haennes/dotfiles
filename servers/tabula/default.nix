{modulesPath, config, lib, pkgs, sshkeys, ...}:
{

  imports = [
    ../proxmox.nix
    #./wireguard.nix
    ./nginx.nix
    ../../modules/syncthing.nix
  ];

  services.syncthing_wrap = {
    enable = true;
    dataDir = "/var/www";
    usr = "nginx";
  };
  networking.hostName = "tabula";
  networking.firewall = {
    allowedUDPPorts = [ 51821 ];
    allowedTCPPorts = [ 22 80 443 ];
  };

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";
} 
