{ pkgs, config, modulesPath, ... }: {

  imports = [ (modulesPath + "/virtualisation/proxmox-image.nix") ];

  #  config.boot.loader = {
  #    systemd-boot.enable = true;
  #    efi.canTouchEfiVariables = true;
  #  };

  options.proxmox = {
    cores = 2;
    memory = 2048;
    name = "${config.networking.hostName}";

  };
}

