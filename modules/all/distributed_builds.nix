{ config, lib, ... }:
lib.mkIf (!config.is_microvm) {
  nix.buildMachines = lib.mkIf (config.services.wireguard-wrapper.enable
    && config.networking.hostName != "deus") [{
      hostName = config.ips.ips.ips.default.deus.wg0;
      protocol = "ssh-ng";
      sshUser = "forward";
      sshKey = "/home/hannses/.ssh/id_ed25519_forward";
      system = "x86_64-linux";
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
      maxJobs = 16;
    }];
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = "  builders-use-substitutes = true\n";
}
