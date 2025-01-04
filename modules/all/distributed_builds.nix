{ config, lib, ... }: {
  config = lib.mkIf (!config.is_microvm
    && config.services.wireguard-wrapper.enable && config.networking.hostName
    != "deus" && config.networking.hostName != "dea") {
      nix.buildMachines = [{
        hostName = config.ips.ips.ips.default.dea.wg0;
        protocol = "ssh-ng";
        sshUser = "forward";
        sshKey = "/home/hannses/.ssh/id_ed25519_forward";
        systems = [ "x86_64-linux" ]
          ++ config.boot.binfmt.emulatedSystems; # TODO this is somewhat a coincidence
        supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
        maxJobs = 16;
        speedFactor = 4;
      }];
      nix.distributedBuilds = true;
      # optional, useful when the builder has a faster internet connection than yours
      nix.extraOptions = "  builders-use-substitutes = true\n";
    };
}
