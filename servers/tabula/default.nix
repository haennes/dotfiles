{ modulesPath, config, lib, pkgs, sshkeys, ... }: {

  imports = [ ../proxmox.nix ./nginx.nix ];

  services.syncthing_wrapper = { enable = true; };
  services.syncthing = {
    dataDir = "/var/www";
    user = "nginx";
  };
  networking.hostName = "tabula";

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";
}
