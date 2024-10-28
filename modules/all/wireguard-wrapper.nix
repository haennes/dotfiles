{ config, lib, ... }:
let
  inherit (lib.my) ip_cidr subnet_cidr;
  ips = config.ips.ips.ips.default;
  simple_ip = name: { "${name}".ips = [ (ip_cidr ips."${name}".wg0) ]; };
  priv_key = hostname:
    lib.my.wireguard.age_obtain_wireguard_priv { inherit hostname; };

in {
  config = lib.mkIf config.services.wireguard-wrapper.enable ({

    services.wireguard-wrapper = {
      kind = lib.mkDefault "wireguard"; # use "normal" backend by default
      connections = [
        [ "tabula" "welt" ]
        [ "porta" "welt" ]
        [ "hermes" "welt" ]
        [ "syncschlawiner" "welt" ]
        [ "syncschlawiner_mkhh" "welt" ]
        [ "handy_hannses" "welt" ]
        [ "thinkpad" "welt" ]
        [ "yoga" "welt" ]
        [ "deus" "welt" ]
        [ "historia" "welt" ]
        [ "fons" "welt" ]
      ];
      nodes = {
        welt = {
          ips = [
            (ip_cidr ips.welt.wg0) # ip of the interfaces
            (subnet_cidr
              ips.welt.wg0) # added to allowedIps of the peers connecting to it
            # welt configures nat seperately to work
          ];
          endpoint =
            "hannses.de:${builtins.toString config.ports.ports.ports.welt.wg0}";
        };
      } // simple_ip "porta" // simple_ip "hermes" // simple_ip "syncschlawiner"
        // simple_ip "syncschlawiner_mkhh" // simple_ip "tabula"
        // simple_ip "historia" // simple_ip "thinkpad" // simple_ip "deus"
        // simple_ip "yoga" // simple_ip "handy_hannses" // simple_ip "fons";
      publicKey = name:
        ((lib.my.wireguard.obtain_wireguard_pub { hostname = name; }).key);
      privateKeyFile = lib.mkIf (config.services.wireguard-wrapper.enable)
        config.age.secrets."wireguard_${config.networking.hostName}_wg0_private".path;
      port = config.ports.ports.curr_ports.wg0;
    };
  } // (priv_key (config.networking.hostName)));
}
