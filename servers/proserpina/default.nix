{ config, pkgs, inputs, ... }: {
  imports = [
    ../../modules/microvm_guest.nix
    inputs.esw-machines.nixosModules.default
  ];

  networking.hostName = "proserpina";

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";

  networking.firewall.allowedTCPPorts = [ config.ports.ports.curr_ports.esw ];

  system.activationScripts.ensure-syncthing-dir = ''
    touch -p /persist/esw2
    chown ${config.services.esw-machines.user}:${config.services.esw-machines.user} /persist/website
  '';

  services.esw-machines = {
    enable = true;
    port = config.ports.ports.curr_ports.esw;
    domain = "0.0.0.0";
    dataFilePath = "/persist/esw2";
  };
}
