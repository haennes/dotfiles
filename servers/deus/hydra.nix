{ config, lib, ... }:
{
  nix.buildMachines = [{
    hostName = "localhost";
    protocol = null;
    system = "x86_64-linux";
    supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    maxJobs = 16;
  }];

  nix.settings.trusted-users = "forward";
}
