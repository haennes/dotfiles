{ config, lib, ... }:
let
  secrets = import ../../lib/wireguard;
  ip_cidr = ip: "${ip}/32";
  ips = config.ips.ips.ips.default;
  __subnet = lib: ip:
    (builtins.concatStringsSep "."
      (lib.lists.take 3 (lib.strings.splitString "." ip)));
  subnet_cidr = lib: ip: let subnet = (__subnet lib ip); in "${subnet}.0/24";
  hostname = config.networking.hostName;
  simple_ip = name: { "${name}".ips = [ (ip_cidr ips."${name}".wg0) ]; };
  priv_key = hostname: secrets.age_obtain_wireguard_priv { inherit hostname; };
  public_ip_ranges =
    [ # this gets suggested on wireguard android as soon as you type in 0.0.0.0/0
      "0.0.0.0/5"
      "8.0.0.0/7"
      "11.0.0.0/8"
      "12.0.0.0/6"
      "16.0.0.0/4"
      "32.0.0.0/3"
      "64.0.0.0/2"
      "128.0.0.0/3"
      "160.0.0.0/5"
      "168.0.0.0/6"
      "172.0.0.0/12"
      "172.32.0.0/11"
      "172.64.0.0/10"
      "172.128.0.0/9"
      "173.0.0.0/8"
      "174.0.0.0/7"
      "176.0.0.0/4"
      "192.0.0.0/9"
      "192.128.0.0/11"
      "192.160.0.0/13"
      "192.169.0.0/16"
      "192.170.0.0/15"
      "192.172.0.0/14"
      "192.176.0.0/12"
      "192.192.0.0/10"
      "193.0.0.0/8"
      "194.0.0.0/7"
      "196.0.0.0/6"
      "200.0.0.0/5"
      "208.0.0.0/4"
      "1.1.1.1/32"
    ];

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
          ];
          endpoint =
            "hannses.de:${builtins.toString config.ports.ports.ports.welt.wg0}";
        };
      } // simple_ip "porta" // simple_ip "hermes" // simple_ip "syncschlawiner"
        // simple_ip "syncschlawiner_mkhh" // simple_ip "tabula"
        // simple_ip "thinkpad" // simple_ip "thinknew" // simple_ip "deus"
        // simple_ip "yoga" // simple_ip "handy_hannses";
      publicKey = name:
        ((secrets.obtain_wireguard_pub { hostname = name; }).key);
      privateKeyFile = lib.mkIf (config.services.wireguard-wrapper.enable)
        config.age.secrets."wireguard_${config.networking.hostName}_wg0_private".path;
      port = config.ports.ports.curr_ports.wg0;
    };
  } // (priv_key (config.networking.hostName)));
}
