hostname:
{ config, ... }: {
  imports = [ ../../../modules/microvm_guest.nix ./vsftpd.nix ];

  services.syncthing-wrapper = { enable = true; };
  services.syncthing = {
    dataDir = "/persist";
    user = "nginx";
  };
  microvm.mem = 256;
  networking.hostName = hostname;

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";
}
