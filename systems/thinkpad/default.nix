{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  services.syncthing-wrapper = { enable = true; };
  services.syncthing = { dataDir = "/syncthing"; };
  virtualisation.docker.enable = true;
  networking.hostName = "thinkpad";
  services.wireguard-wrapper.enable = true;
}
