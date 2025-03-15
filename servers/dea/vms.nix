{ specialArgs, lib, ... }:
let
  hostnames =
    [ "tabula_1" "minerva" "vertumnus" "proserpina_1" "historia" "pales_1" ];
  inherit (lib) mkMerge listToAttrs map;
in {
  imports = (map (hostname:
    { ... }: {
      age.secrets."sshkeys/${hostname}/age_key" = {
        path = "/persistant/microvms/${hostname}/age_key";
        file = ../../secrets/sshkeys/${hostname}/age_key.age;
        symlink = false;
      };
      age.secrets."sshkeys/${hostname}/ssh_host_ed25519_key" = {
        path = "/persistant/microvms/${hostname}/ssh/ssh_host_ed25519_key";
        file = ../../secrets/sshkeys/${hostname}/ssh_host_ed25519_key.age;
        symlink = false;
      };
      age.secrets."sshkeys/${hostname}/ssh_host_rsa_key" = {
        path = "/persistant/microvms/${hostname}/ssh/ssh_host_rsa_key";
        file = ../../secrets/sshkeys/${hostname}/ssh_host_rsa_key.age;
        symlink = false;
      };
    }) hostnames);
  microvm.vms = {
    tabula_1 = {
      inherit specialArgs;
      config = ../../vms/instances/tabula_1.nix;
      pkgs = null;
    };

    minerva = {
      inherit specialArgs;
      config = ../../vms/singletons/minerva;
      pkgs = null;
    };

    vertumnus = {
      inherit specialArgs;
      config = ../../vms/singletons/vertumnus;
      pkgs = null;
    };
    proserpina_1 = {
      inherit specialArgs;
      config = ../../vms/instances/proserpina_1.nix;
      pkgs = null;
    };
    historia = {
      inherit specialArgs;
      config = ../../vms/singletons/historia;
      pkgs = null;
    };
    #pales_1 = {
    #  inherit specialArgs;
    #  config = ../../vms/instances/pales_1.nix;
    #  pkgs = null;
    #};

  };

  #microvm.vms = lib.my.mkVMS {
  #  names = [
  #    "tabula"
  #    "fons"
  #    "historia"
  #    "minerva"
  #    "vertumnus"
  #    "concordia"
  #    "proserpina"
  #  ];
  #  inherit specialArgs;
  #};
}
