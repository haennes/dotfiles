{ ... }: {

  imports = [
    ../proxmox.nix
    #    ./nginx.nix
  ];

  networking.hostName = "hermes";
  networking.firewall = {
    allowedUDPPorts = [ 51821 ];
    allowedTCPPorts = [ 22 80 443 ];
  };

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";
}
