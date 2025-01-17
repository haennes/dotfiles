{ config, lib, inputs, ... }@mod_inputs:
let top_zones = [ "local.hannses.de" ];
in {
  config = {
    services.nsd = rec {
      enable = true;
      port = config.ports.ports.ports.${config.networking.hostName}.dns;
      interfaces = [ "0.0.0.0" ];
      #ipTransparent = true;
      #ipFreebind = true;
      #serverCount = 1;
      #reuseport = serverCount > 1;
      #roundRobin = true;
      #extraConfig = ''
      #  server:
      #    refuse-any: yes
      #'';
      zones = let
        mkZone = domain: {
          name = domain;
          value = {
            data = inputs.dns.lib.toString domain
              (import ../../dns-zones/${domain}.nix mod_inputs);
          };
        };
      in lib.listToAttrs (lib.map mkZone top_zones);
    };
    networking.firewall = {
      allowedTCPPorts = [ config.services.nsd.port ];
      allowedUDPPorts = [ config.services.nsd.port ];
    };
  };
}
