{ ... }: {

  imports = [
    ../proxmox.nix
    #./nginx.nix
  ];

  #  services.syncthing_wrapper = {
  #    enable = true;
  #  };
  #  services.syncthing = {
  #    dataDir = "/var/www";
  #    user = "nginx";
  #  };
  networking.hostName = "tabula_mkhh";
  networking.firewall = {
    allowedUDPPorts = [ 51821 ];
    allowedTCPPorts = [ 22 80 443 ];
  };

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";
}
