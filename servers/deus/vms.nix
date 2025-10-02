{ specialArgs, ... }:
let hostnames = [ "ludus" ];
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
    # ludus = {
    #   inherit specialArgs;
    #   config = ../../vms/singletons/ludus;
    #   pkgs = null;
    # };
  };
}
