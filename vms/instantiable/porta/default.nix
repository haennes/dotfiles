{ ... }:
{

  #imports = [ ../proxmox.nix ];

  networking.hostName = "porta"; # Define your hostname.

  services.wireguard-wrapper.enable = true;

}
