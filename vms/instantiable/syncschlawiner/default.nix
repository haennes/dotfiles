{ config, ... }: {
  system.stateVersion = "23.11";
  imports = [ ./nextcloud.nix ./ipfs.nix ];
  boot.kernel.sysctl = { "fs.inotify.max_user_watches" = 204800; };
  services.syncthing = {
    dataDir = "/data/syncthing";
    user = "nextcloud";
  };
  services.syncthing_wrapper = { enable = true; };

  networking.hostName = "syncschlawiner"; # Define your hostname.

  services.wireguard-wrapper.enable = true;

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/c01f7a7e-f5ca-4642-a159-bbc8d86e23b6";
    fsType = "ext4";
  };

}
