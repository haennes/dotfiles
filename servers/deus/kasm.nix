{ config, ... }:
let gui_port = config.ports.ports.ports.deus.kasmweb.gui;
in {
  services.kasmweb = {
    enable = true;
    #listenPort = gui_port;
    datastorePath = "/kasmweb";
  };
  networking.firewall.allowedTCPPorts = [ config.services.kasmweb.listenPort ];
}
