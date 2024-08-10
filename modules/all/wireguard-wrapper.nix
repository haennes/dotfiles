{config, lib, ips, ports, ...}:
let
  secrets = import ../../lib/wireguard;
  inherit (ips) ip_cidr subnet_cidr;
  hostname = config.networking.hostName;
  simple_ip = name: { "${name}".ips = [ (ip_cidr ips."${name}".wg0) ]; };
  priv_key = hostname: secrets.age_obtain_wireguard_priv { inherit hostname; };
in
{

    services.wireguard-wrapper = {
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
        [ "mainpc" "welt" ]
      ];
      nodes = {
        welt = {
          ips = [ (ip_cidr ips.welt.wg0) (subnet_cidr lib ips.welt.wg0) ];
          endpoint = "hannses.de:${builtins.toString ports.welt.wg0}";
        };
      } // simple_ip "porta" // simple_ip "hermes" // simple_ip "syncschlawiner"
        // simple_ip "syncschlawiner_mkhh" // simple_ip "tabula"
        // simple_ip "thinkpad" // simple_ip "thinknew" // simple_ip "mainpc"
        // simple_ip "yoga" // simple_ip "handy_hannses";
      publicKey = name:
        ((secrets.obtain_wireguard_pub { hostname = name; }).key);
      privateKeyFile = lib.mkIf (config.services.wireguard-wrapper.enable)
        config.age.secrets."wireguard_${config.networking.hostName}_wg0_private".path;
      port = ports."${hostname}".wg0;
    };
} // (priv_key (config.networking.hostName))
