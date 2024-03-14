{ config, pkgs,  ... }:
{
    imports = [ 
        ./hardware-configuration.nix
    ];
    # Bootloader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;

    networking.hostName = "thinknew"; # Define your hostname.
    services.syncthing_wrapper = {
      enable = true;
    };
    services.syncthing = {
      dataDir = "/home/hannses";
      user = "hannses";
    };
    virtualisation.docker.enable = true;
    services.wireguard-wrapper.enable = true;
}
