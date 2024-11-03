{ config, ... }: {
  system.stateVersion = "23.11";
  imports = [ ../proxmox.nix ./nextcloud.nix ./ipfs.nix ];
  boot.kernel.sysctl = { "fs.inotify.max_user_watches" = 204800; };
  services.syncthing = {
    dataDir = "/data/syncthing";
    user = "nextcloud";
  };
  services.syncthing_wrapper = { enable = true; };

  networking.hostName = "syncschlawiner"; # Define your hostname.

  services.wireguard-wrapper.enable = true;

}
