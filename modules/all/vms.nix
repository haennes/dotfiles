{ config, lib, specialArgs, ... }:
let
  inherit (lib) mkOption mapAttrsToList isString flatten filter imap1;
  inherit (lib.types) attrsOf either listOf str;
in {
  options = {
    vms_map = mkOption {
      type = attrsOf (either str (listOf str));
      description = ''
        vm_base_name  = "host"
        vm_base_nameb = ["hosta" "hostb" "hostc" ]
        -> host will host one vm_base_name vm
        -> hosta will host vm_base_nameb_1 hostb will host vm_base_nameb_2...
      '';
    };
    vms_curr = mkOption { };
  };

  config = rec {
    vms_map = {
      tabula = [ "deus" "dea" "yoga" ];
      #tabula = [ "dea" ];
      proserpina = [ "deus" "dea" ];
      #porta = [ "deus" "dea" ];
      #concordia = [ "deus" "dea" ];

      #vertumnus = "dea";
      #fons = "dea";
      #grapheum = "dea";
      #hermes = "dea";
      historia = "dea";
      #minerva = "dea";
    };
    vms_curr = let
      hostname = "yoga";
      #config.networking.hostName;
    in filter (v: v != null) (flatten (mapAttrsToList (n: v:
      if (isString v) then
        (if (v == hostname) then {
          name = n;
          value = {
            #inherit specialArgs;
            #config = import ../../vms/singletons/${toString n};
            config = import (./. + "../../../vms/singletons/${toString n}");
            pkgs = null;
          };
        } else
          null)
      else
        imap1 (i: host:
          if (host == hostname) then ({
            name = "${n}_${toString i}";
            value = {
              #inherit specialArgs;
              #config = import builtins.toPath ("../../vms/instances/${toString n}_${toString i}");
              config =
                import (./. + "../../../vms/instances/${n}_${toString i}.nix");
              pkgs = null;
            };
          }) else
            (null)) v) vms_map));

    microvm.vms = lib.mkIf config.is_microvm_host (lib.listToAttrs vms_curr);

  };
}
