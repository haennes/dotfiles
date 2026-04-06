hostname:
{ config, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    #../proxmox.nix
    ../../../modules/sys
    ./gitlab-runner.nix
    ./nginx.nix
    # keep-sorted end
  ];

  is_server = true;
  is_client = false;
  is_microvm = true;

  microvm = {
    mem = 8193;
    writableStoreOverlay = "/nix/.rw-store";
  };
  microvm.volumes = [
    {
      image = "nix-store-overlay.img";
      mountPoint = config.microvm.writableStoreOverlay;
      size = 2048000;
    }
  ];
  networking.hostName = hostname;

  services.wireguard-wrapper.enable = true;

}
