{ config, pkgs,  ... }:

{
    imports = [ 
        ./hardware-configuration.nix
	../../modules/syncthing.nix
        ];
    services.syncthing_wrap = {
      enable = true;
      dataDir = "/home/hannses";
    };
    virtualisation.docker.enable = true;
    networking.hostName = "thinkpad";
    services.wireguard-wrapper.enable = true;
}
