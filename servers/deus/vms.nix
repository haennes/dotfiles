{ specialArgs, ... }:
let
  hostnames = [ "ludus" "proserpina_2"];
in
{
  imports = (
    map (
      hostname:
      { ... }:
      {
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
      }
    ) hostnames
  );
  microvm.vms = {
    proserpina_2 = {
      inherit specialArgs;
      config = ../../vms/instances/proserpina_2.nix;
      pkgs = null;
    };
    # ludus = {
    #   inherit specialArgs;
    #   config = ../../vms/singletons/ludus;
    #   pkgs = null;
    # };
  };
}
