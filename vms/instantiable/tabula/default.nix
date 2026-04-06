hostname:
{ config, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    #../proxmox.nix
    ../../../modules/sys
    ./nginx.nix
    # keep-sorted end
  ];

  is_server = true;
  is_client = false;
  is_microvm = true;

  services.syncthing-wrapper = {
    enable = true;
  };
  services.syncthing = {
    dataDir = "/persist";
    user = "nginx";
  };
  microvm.mem = 256;
  networking.hostName = hostname;

  services.wireguard-wrapper.enable = true;

}
