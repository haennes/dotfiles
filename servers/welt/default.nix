{ modulesPath, config, lib, pkgs, sshkeys, ... }: {

  imports = [ ./hardware-configuration.nix ./nginx.nix ./dns.nix ];
  boot.loader = {
    grub.enable = true;
    grub.device = "/dev/sda15";
    grub.forceInstall = true;
  };
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking.hostName = "welt";
  networking.domain = "hannses.de";
  networking.firewall = { #should not be needed as automatically opened
    allowedUDPPorts = [ 51821 ];
    allowedTCPPorts = [ 22 80 443 ];
  };

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";
}
