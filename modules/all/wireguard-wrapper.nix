{ config, lib, ... }:
let
  inherit (lib.my) ip_cidr subnet_cidr;
  ips = config.ips.ips.ips.default;
  simple_ip = name: { "${name}".ips = [ (ip_cidr ips."${name}".wg0) ]; };
  simple_ips = names: lib.mergeAttrsList (map (v: simple_ip v) names);
  priv_key = hostname:
    lib.my.wireguard.age_obtain_wireguard_priv { inherit hostname; };

in {
  config = lib.mkIf config.services.wireguard-wrapper.enable ({
    wg-friendly-peer-names = {
      wggn.enable = true;
      enable = true;
    };

    services.wireguard-wrapper = {
      RestartOnFailure.enable = true;
      kind = lib.mkDefault "wireguard"; # use "normal" backend by default
      connections = [
        [ "tabula" "welt" ]
        [ "tabula_1" "welt" ]
        [ "tabula_3" "welt" ]
        [ "fabulinus" "welt" ]
        [ "porta" "welt" ]
        [ "syncschlawiner" "welt" ]
        [ "syncschlawiner_mkhh" "welt" ]
        [ "handy_hannses" "welt" ]
        [ "thinkpad" "welt" ]
        [ "yoga" "welt" ]
        [ "deus" "welt" ]
        [ "dea" "welt" ]
        [ "historia" "welt" ]
        [ "fons" "welt" ]
        [ "minerva" "welt" ]
        [ "vertumnus" "welt" ]
        [ "concordia" "welt" ]
        [ "proserpina_1" "welt" ]
        [ "proserpina_2" "welt" ]
        [ "pales_1" "welt" ]
        [ "thinknew" "welt" ]
        [ "mkhh" "welt" ]
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
      } // (simple_ips [
        "porta"
        "syncschlawiner"
        "syncschlawiner_mkhh"
        "tabula"
        "tabula_1"
        "tabula_3"
        "fabulinus"
        "historia"
        "thinkpad"
        "deus"
        "dea"
        "yoga"
        "handy_hannses"
        "fons"
        "minerva"
        "vertumnus"
        "concordia"
        "proserpina_1"
        "proserpina_2"
        "pales_1"
        "thinknew"
        "mkhh"
      ]);
      publicKey = name:
        ((lib.my.wireguard.obtain_wireguard_pub { hostname = name; }).key);
      privateKeyFile = lib.mkIf (config.services.wireguard-wrapper.enable)
        config.age.secrets."wireguard_${config.networking.hostName}_wg0_private".path;
      port = config.ports.ports.curr_ports.wg0;
    };
  } // (priv_key (config.networking.hostName)));
}
