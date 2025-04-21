{ ... }: {
  imports = [
    ./nextcloud.nix
    ./hedgedoc.nix
    ../../../modules/microvm_guest.nix
    #./ldap.nix
  ];
  services.wireguard-wrapper.enable = true;

  microvm.mem = 4000;
  networking.hostName = "mkhh";
}
