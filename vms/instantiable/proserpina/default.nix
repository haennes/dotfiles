hostname:
{ config, inputs, ... }: {
  imports = [
    ../../../modules/microvm_guest.nix
    inputs.esw-machines.nixosModules.default
    #inputs.syncthing-wrapper.nixosModules.default
  ];

  networking.hostName = hostname;

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";

  networking.firewall.allowedTCPPorts = [ config.ports.ports.curr_ports.esw ];

  system.activationScripts.ensure-syncthing-dir = ''
    mkdir -p /persist/esw-machines
    touch  /persist/esw-machines/esw
    chown -R ${config.services.esw-machines.user}:${config.services.esw-machines.user} /persist/esw-machines
  '';

  services.syncthing-wrapper = { enable = true; };
  services.syncthing = {
    dataDir = "/persist";
    user = config.services.esw-machines.user;
    group = config.services.esw-machines.user;
  };

  services.esw-machines = {
    enable = true;
    port = config.ports.ports.curr_ports.esw;
    domain = "0.0.0.0";
    dataFilePath = "/persist/esw-machine__esw-machines/esw";
  };
}
