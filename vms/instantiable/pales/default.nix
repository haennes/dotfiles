hostname:
{ ... }: {
  imports = [
    #../proxmox.nix
    ../../../modules/microvm_guest.nix
    ./nginx.nix
  ];
  microvm.mem = 256;
  networking.hostName = hostname;

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";
}
