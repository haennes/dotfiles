{ config, pkgs, sshkeys, ... }: {
  system.stateVersion = "23.11";
  imports = [ ../proxmox.nix ./nextcloud.nix ];

  networking.hostName = "syncschlawiner_mkhh"; # Define your hostname.

  services.wireguard-wrapper.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 24 80 8080 443 ];
  #networking.firewall.allowedUDPPorts = [ 25565 ];

  fileSystems."/nextcloud" = {
    device = "/dev/disk/by-uuid/22e0870b-391e-4666-8d22-53d2b4497ce0";
    fsType = "ext4";
  };

}
