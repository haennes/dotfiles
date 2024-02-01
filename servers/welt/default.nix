{modulesPath, config, lib, pkgs, sshkeys, ...}:
{

  imports = [
    #./wireguard.nix
    ./hardware-configuration.nix
    ./nginx.nix
    ./dns.nix
  ];
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking.hostName = "welt";
  networking.domain = "hannses.de";
  networking.firewall = {
    allowedUDPPorts = [ 51821 ];
    allowedTCPPorts = [ 22 80 443 ];
  };


  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";
} 
