{ config, ... }: {
  imports = [
    #../proxmox.nix
    ../../modules/microvm_guest.nix
    ./nginx.nix
  ];

  system.activationScripts.ensure-syncthing-dir =
    "mkdir -p /persist/website/.stfolder && chown -R ${config.services.syncthing.user} /persist/website";
  services.syncthing_wrapper = { enable = true; };
  services.syncthing = {
    dataDir = "/persist";
    user = "nginx";
  };
  microvm.mem = 256;
  networking.hostName = "tabula";

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";
}
