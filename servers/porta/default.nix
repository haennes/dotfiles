{ config, pkgs, sshkeys, ... }: {
  system.stateVersion = "23.11";

  imports = [ ../proxmox.nix ];

  networking.hostName = "porta"; # Define your hostname.

  users.users.root.openssh.authorizedKeys.keys =
    [ sshkeys.hannses sshkeys.root_thinkpad ];

  services.wireguard-wrapper.enable = true;

  # Open ports in the firewall.
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 22 24 8000 ];
      allowedUDPPorts = [ 51821 ];
    };
    nat = {
      enable = true;
      internalInterfaces = [ "wg0" ];
      externalInterface = "eth0";
      forwardPorts = [
        {
          sourcePort = 80;
          proto = "tcp";
          destination = "192.168.1.3:80";
        }
        {
          sourcePort = 8000;
          proto = "tcp";
          destination = "192.168.1.3:8000";
        }
        {
          sourcePort = 24;
          proto = "tcp";
          destination = "192.168.1.3:24";
        }
      ];
    };
  };
}
