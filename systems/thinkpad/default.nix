{ config, pkgs,  ... }:

{
    imports = [ 
        ./hardware-configuration.nix
	../../modules/syncthing.nix
        #./wireguard.nix
        ];
    services.syncthing_wrap = {
      enable = true;
      dataDir = "/home/hannses";
    };
    networking.hostName = "thinkpad";
    services.wireguard-wrapper.enable = true;
}
