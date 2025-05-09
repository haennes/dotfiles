hostname:
{ config, ... }: {
  imports = [
    #../proxmox.nix
    ../../../modules/microvm_guest.nix
    ./nginx.nix
    ./gitlab-runner.nix
  ];
  microvm = {
    mem = 8193;
    writableStoreOverlay = "/nix/.rw-store";
  };
  microvm.volumes = [{
    image = "nix-store-overlay.img";
    mountPoint = config.microvm.writableStoreOverlay;
    size = 2048000;
  }];
  networking.hostName = hostname;

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";
}
