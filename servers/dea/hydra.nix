{ config, lib, pkgs, ... }:
let port = config.ports.ports.curr_ports.hydra;
in {
  age.secrets."hydra/users/hannses.age".file =
    ../../secrets/hydra/users/hannses.age;
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ port ];
  services.hydra = rec {
    enable = true;
    hydraURL = "http://${config.ips.ips.ips.default.dea.wg0}:${toString port}";
    inherit port;
    notificationSender = "hydra@localhost";
    useSubstitutes = true;
    minimumDiskFreeEvaluator = 20; # ensure we have at least 20GB
    minimumDiskFree = minimumDiskFreeEvaluator;

  };

  #TODO doesnt work
  #make this a upstream patch. this fails if this is run when hydra get enabled for the first time
  #system.activationScripts.createHydraUser =
  #  lib.mkIf config.services.hydra.enable {
  #    text = ''
  #      pw=$(cat ${
  #        config.age.secrets."hydra/users/hannses.age".path
  #      }| tr -d \\n | ${pkgs.libargon2}/bin/argon2 "$(LC_ALL=C tr -dc '[:alnum:]' < /dev/urandom | head -c16)" -id -t 3 -k 262144 -p 1 -l 16 -e)

  #      runuser -u hydra -- ${pkgs.hydra_unstable}/bin/hydra-create-user hannses --password-hash $pw --role admin
  #    '';
  #    deps = [ "agenixInstall" ];
  #  };

  nix.buildMachines = [{
    hostName = "localhost";
    protocol = null;
    systems = [ "x86_64-linux" ] ++ config.boot.binfmt.emulatedSystems;
    supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    maxJobs = 16;
  }];

  nix.settings.trusted-users = [ "forward" ];
  nix.settings.allowed-uris =
    [ "github:" "git+https://github.com/" "git+ssh://github.com/" ];
}
