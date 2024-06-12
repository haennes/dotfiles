{ pkgs, config, modulesPath, lib, ... }: {

  imports = [ (modulesPath + "/virtualisation/proxmox-image.nix") ];

  #  config.boot.loader = {
  #    systemd-boot.enable = true;
  #    efi.canTouchEfiVariables = true;
  #  };

  config.proxmox = {

    qemuConf = {
      #cores = 2;
      #memory = 2048;
      name = "${config.networking.hostName}";
    };

    cloudInit.enable = false;

  };
}

