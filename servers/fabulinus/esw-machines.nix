{ config, ... }: {
  networking.firewall.allowedTCPPorts = [ config.ports.ports.curr_ports.esw ];

  system.activationScripts.ensure-syncthing-dir = ''
    touch -p /persist/esw2
    chown ${config.services.esw-machines.user}:${config.services.esw-machines.user} /persist/website
  '';

  services.syncthing_wrapper.enable = true;

  services.syncthing = {
    dataDir = "/persist";
    user = config.services.esw-machines.user;
  };

  services.esw-machines = {
    enable = true;
    port = config.ports.ports.curr_ports.esw;
    domain = "0.0.0.0";
    dataFilePath = "/persist/esw2";
  };
}
