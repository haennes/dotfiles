{ config, lib, ips, hports, ports, ... }:
let
  secrets = import ../../lib/wireguard;
  inherit (ips) ip_cidr subnet_cidr public_ip_ranges;
  hostname = config.networking.hostName;
  simple_ip = name: { "${name}".ips = [ (ip_cidr ips."${name}".wg0) ]; };
  priv_key = hostname: secrets.age_obtain_wireguard_priv { inherit hostname; };
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
        [ "thinknew" "welt" ]
        [ "yoga" "welt" ]
        [ "deus" "welt" ]
      ];
      nodes = {
        welt = {
          ips = [
            (ip_cidr ips.welt.wg0) # ip of the interfaces
            (subnet_cidr lib
              ips.welt.wg0) # added to allowedIps of the peers connecting to it
            # welt configures nat seperately to work
          ] ++ public_ip_ranges;
          endpoint = "hannses.de:${builtins.toString ports.welt.wg0}";
        };
      } // simple_ip "porta" // simple_ip "hermes" // simple_ip "syncschlawiner"
        // simple_ip "syncschlawiner_mkhh" // simple_ip "tabula"
        // simple_ip "thinkpad" // simple_ip "thinknew" // simple_ip "deus"
        // simple_ip "yoga" // simple_ip "handy_hannses";
      publicKey = name:
        ((secrets.obtain_wireguard_pub { hostname = name; }).key);
      privateKeyFile = lib.mkIf (config.services.wireguard-wrapper.enable)
        config.age.secrets."wireguard_${config.networking.hostName}_wg0_private".path;
      port = hports.wg0;
    };
  } // (priv_key (config.networking.hostName)));
}
