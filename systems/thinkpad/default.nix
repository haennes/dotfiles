{ config, pkgs,  ... }:
{
    imports = [ 
        ./hardware-configuration.nix
    ];
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    services.syncthing_wrapper = {
      enable = true;
    };
    services.syncthing = {
      dataDir = "/home/hannses";
      user = "hannses";
    };
    virtualisation.docker.enable = true;
    networking.hostName = "thinkpad";
    services.wireguard-wrapper.enable = true;
}
