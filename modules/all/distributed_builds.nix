{ config, lib, ... }: {
  config = lib.mkIf (!config.is_microvm
    && config.services.wireguard-wrapper.enable && config.networking.hostName
    != "deus") {
      nix.buildMachines = [{
        hostName = config.ips.ips.ips.default.deus.wg0;
        protocol = "ssh-ng";
        sshUser = "forward";
        sshKey = "/home/hannses/.ssh/id_ed25519_forward";
        systems = [ "x86_64-linux" ]
          ++ config.boot.binfmt.emulatedSystems; # TODO this is somewhat a coincidence
        supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
        maxJobs = 16;
      }];
      nix.distributedBuilds = true;
      # optional, useful when the builder has a faster internet connection than yours
      nix.extraOptions = "  builders-use-substitutes = true\n";
    };
}
