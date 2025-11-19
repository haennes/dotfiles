{ config, lib, ... }:
let
  inherit (lib.my) ip_cidr subnet_cidr;
  inherit (lib) split mapAttrsToList;
  ips = config.ips.ips.ips.default;
  hostname = config.networking.hostName;

  # simple_ip = name: { "${name}".ips = [ (ip_cidr ips."${name}".wg0) ]; };
  name_if_from_str = name_if:
    let
      name_if_l = split "%" name_if;
      name = lib.head name_if_l;
      interface = lib.last name_if_l;
    in { inherit name interface; };
  simple_ip = name_if:
    let
      name_if_a = name_if_from_str name_if;
      inherit (name_if_a) name interface;
    in {
      ${name}.ifs.${interface} = { ip = ip_cidr ips.${name}.${interface}; };
    };
  simple_ips = names: lib.mkMerge (map (v: simple_ip v) names);
  cfg = config.services.wireguard-wrapper;
  map_to_cfg_nodes_from_str = nodes: connections:
    map (connection:
      map (node:
        let name_if = name_if_from_str node;
        in nodes.${name_if.name}.ifs.${name_if.interface}) connection)
    connections;

in {
  config = lib.mkIf config.services.wireguard-wrapper.enable ({
    wg-friendly-peer-names = {
      wggn = {
        enable = true;
        enableSUID = true;
      };
      enable = true;
    };

    networking.firewall.allowedTCPPorts =
      [ 51821 51822 ]; # TODO this should use port config
    services.wireguard-wrapper = {
      # RestartOnFailure.enable = true;
      kind = lib.mkDefault "wireguard"; # use "normal" backend by default
      connections = map_to_cfg_nodes_from_str cfg.nodes [
        [ "tabula%wg0" "welt%wg0" ]
        [ "tabula_1%wg0" "welt%wg0" ]
        [ "tabula_3%wg0" "welt%wg0" ]
        [ "fabulinus%wg0" "welt%wg0" ]
        [ "porta%wg0" "welt%wg0" ]
        [ "syncschlawiner%wg0" "welt%wg0" ]
        [ "syncschlawiner_mkhh%wg0" "welt%wg0" ]
        [ "handy_hannses%wg0" "welt%wg0" ]
        [ "thinkpad%wg0" "welt%wg0" ]
        [ "yoga%wg0" "welt%wg0" ]
        [ "deus%wg0" "welt%wg0" ]
        [ "dea%wg0" "welt%wg0" ]
        [ "historia%wg0" "welt%wg0" ]
        [ "fons%wg0" "welt%wg0" ]
        [ "minerva%wg0" "welt%wg0" ]
        [ "vertumnus%wg0" "welt%wg0" ]
        [ "concordia%wg0" "welt%wg0" ]
        [ "proserpina_1%wg0" "welt%wg0" ]
        [ "proserpina_2%wg0" "welt%wg0" ]
        [ "pales_1%wg0" "welt%wg0" ]
        [ "thinknew%wg0" "welt%wg0" ]
        [ "mkhh%wg0" "welt%wg0" ]
        [ "ludus%wg0" "welt%wg0" ]
        [ "ludus%wg1" "welt%wg1" ]
        [ "yoga%wg1" "welt%wg1" ]
        [ "joni%wg1" "welt%wg1" ]
        [ "felix%wg1" "welt%wg1" ]
        [ "terminus%wg0" "welt%wg0" ]
        [ "janus_1%wg0" "welt%wg0" ]
        [ "hesperos_1%wg0" "welt%wg0" ]
      ];
      nodes = lib.mkMerge [
        {
          welt = {
            ifs = {
              wg0 = {
                ip = ips.welt.wg0;
                allowedIPs = [
                  # (ip_cidr ips.welt.wg0) # ip of the interfaces
                  (subnet_cidr
                    ips.welt.wg0) # added to allowedIps of the peers connecting to it
                  # welt configures nat seperately to work
                ];
                endpoint = "${ips.welt.ens3}:${
                    builtins.toString config.ports.ports.ports.welt.wg0
                  }";
              };
              wg1 = {
                ip = ip_cidr ips.welt.wg1;
                allowedIPs = [
                  (subnet_cidr
                    ips.welt.wg1) # added to allowedIps of the peers connecting to it

                ];

                endpoint = "${ips.welt.ens3}:${
                    builtins.toString config.ports.ports.ports.welt.wg1
                  }";
              };
            };
          };
        }
        (simple_ips [
          "porta%wg0"
          "syncschlawiner%wg0"
          "syncschlawiner_mkhh%wg0"
          "tabula%wg0"
          "tabula_1%wg0"
          "tabula_3%wg0"
          "fabulinus%wg0"
          "historia%wg0"
          "thinkpad%wg0"
          "deus%wg0"
          "dea%wg0"
          "yoga%wg0"
          "handy_hannses%wg0"
          "fons%wg0"
          "minerva%wg0"
          "vertumnus%wg0"
          "concordia%wg0"
          "proserpina_1%wg0"
          "proserpina_2%wg0"
          "pales_1%wg0"
          "thinknew%wg0"
          "mkhh%wg0"
          "ludus%wg0"
          "ludus%wg1"
          "yoga%wg1"
          "joni%wg1"
          "felix%wg1"
          "terminus%wg0"
          "janus_1%wg0"
          "hesperos_1%wg0"
        ])
      ];
      publicKeyFunc = { nodeName, ifName }:
        ((lib.my.wireguard.obtain_wireguard_pub {
          hostname = nodeName;
          interface = ifName;
        }).key);
      privateKeyFileFunc = { nodeName, ifName, ... }:
        lib.mkIf (config.services.wireguard-wrapper.enable)
        config.age.secrets."wireguard_${nodeName}_${ifName}_private".path;
      # ports.defaultPort = config.ports.ports.curr_ports.wg0;
      ports.portFn = { node, interface, ... }:
        config.ports.ports.ports.${node}.${interface};
    };
    # test = lib.mkForce
    #   (mapAttrsToList (interface: _: interface) cfg.nodes.${hostname}.ifs);
    age = lib.my.recursiveMerge (mapAttrsToList (interface: _:

      lib.my.wireguard.age_obtain_wireguard_priv {
        inherit hostname interface;
      }) cfg.nodes.${hostname}.ifs);
  });
  # // (priv_key (config.networking.hostName)));
}
