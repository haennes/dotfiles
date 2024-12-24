{ config, lib, ... }: {
  system.stateVersion = "23.11";
  imports = [ ./nextcloud.nix ./ipfs.nix ../../../modules/microvm_guest.nix ];

  microvm.mem = 4096;
  microvm.vcpu = 4;

  networking.hostName = "concordia"; # Define your hostname.
  microvm.shares = [{
    source = "/data";
    mountPoint = "/data";
    tag = "data-${config.networking.hostName}";
    proto = "virtiofs";
  }];

  services.wireguard-wrapper.enable = true;

}
