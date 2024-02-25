{ pkgs, config, modulesPath, ... }: {
  imports = [ (modulesPath + "/virtualisation/proxmox-image.nix") ];
  options.proxmox = {
    cores = 2;
    memory = 2048;
    name = "${config.hostname}";

  };
}

