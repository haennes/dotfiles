{ config, lib, ... }:
{
  system.stateVersion = "23.11";
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ../../../modules/microvm_guest.nix
    ./ipfs.nix
    ./nextcloud.nix
    # keep-sorted end
  ];

  microvm.mem = 4096;
  microvm.vcpu = 4;

  networking.hostName = "concordia"; # Define your hostname.
  microvm.shares = [
    {
      source = "/data";
      mountPoint = "/data";
      tag = "data-${config.networking.hostName}";
      proto = "virtiofs";
    }
  ];

  services.wireguard-wrapper.enable = true;

}
