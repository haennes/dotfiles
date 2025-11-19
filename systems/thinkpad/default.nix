{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
    default = "1";
  };

  services.syncthing-wrapper = { enable = true; };
  services.syncthing = { dataDir = "/syncthing"; };
  virtualisation.docker.enable = true;
  networking.hostName = "thinkpad";
  services.wireguard-wrapper.enable = true;
  users.users.syncthing.uid = 237;
  users.groups.syncthing.gid = 237;
}
