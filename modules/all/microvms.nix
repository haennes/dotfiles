{ config, lib, specialArgs, inputs, ... }:
{ }
#{
#imports = [ inputs.microvm.nixosModules.host ];
#config = lib.mkIf config.is_microvm_host ({
#  microvm.vms = (let
#    inherit (lib)
#      flatten mapAttrsToList isString imap1 filter listToAttrs map;
#    inherit (builtins) toString;
#    #[{host=..., guest=...}]
#    vms_list = flatten (mapAttrsToList (className: host_s:
#      if isString host_s then [rec {
#        host = host_s;
#        guest = className;
#        config = import ../../vms/singletons/${guest};
#        #config = ../../vms/singletons/${guest};
#      }] else
#        (imap1 (i: host: rec {
#          inherit host;
#          guest = "${className}_${toString i}";
#          config =
#            import (builtins.toPath "../../vms/instances/${guest}.nix");
#          #config = ../../vms/instantiable/${guest}.nix;
#        }) host_s)) config.vms_map);
#    host_vms = filter (set: set.host == config.networking.hostName) vms_list;
#  in listToAttrs (map (vm: {
#    name = vm.guest;
#    value = {
#      inherit config;
#      #specialArgs
#      pkgs = null;
#    };
#  }) host_vms));
#});
#}

#lib.mkIf config.is_microvm_host (let
#  inherit (lib) mkOption mapAttrsToList isString flatten filter imap1;
#  inherit (lib.types) attrsOf either listOf str;
#  vms_map = {
#    tabula = [ "deus" "dea" "yoga" ];
#    #tabula = [ "dea" ];
#    proserpina = [ "deus" "dea" ];
#    #porta = [ "deus" "dea" ];
#    #concordia = [ "deus" "dea" ];
#
#    #vertumnus = "dea";
#    #fons = "dea";
#    #grapheum = "dea";
#    #hermes = "dea";
#    historia = "dea";
#    #minerva = "dea";
#  };
#
#in (lib.my.recursiveMerge (map (vm:
#  let hostname = vm.name;
#  in {
#    microvm.vms = {
#      ${vm.name} = {
#        inherit specialArgs;
#        config = import (../. + vm.value.config);
#        #../../vms/instances/tabula_1.nix;
#        pkgs = null;
#      };
#    };
#
#    age.secrets."sshkeys/${hostname}/age_key" = {
#      path = "/persistant/microvms/${hostname}/age_key";
#      file = ../../secrets/sshkeys/${hostname}/age_key.age;
#      symlink = false;
#    };
#    age.secrets."sshkeys/${hostname}/ssh_host_ed25519_key" = {
#      path = "/persistant/microvms/${hostname}/ssh/ssh_host_ed25519_key";
#      file = ../../secrets/sshkeys/${hostname}/ssh_host_ed25519_key.age;
#      symlink = false;
#    };
#    age.secrets."sshkeys/${hostname}/ssh_host_rsa_key" = {
#      path = "/persistant/microvms/${hostname}/ssh/ssh_host_rsa_key";
#      file = ../../secrets/sshkeys/${hostname}/ssh_host_rsa_key.age;
#      symlink = false;
#    };
#  }) config.vms_curr)))
