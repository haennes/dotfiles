{ config, lib, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ../../../modules/sys
    ./ipfs.nix
    ./nextcloud.nix
    # keep-sorted end
  ];

  is_server = true;
  is_client = false;
  is_microvm = true;
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
