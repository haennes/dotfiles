{ config, pkgs,  ... }:
{
    imports = [ 
        ./hardware-configuration.nix
    ];
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
