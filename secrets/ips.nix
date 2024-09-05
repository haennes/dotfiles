{lib, ...}:
let
  recursiveMerge = listOfAttrsets:
          lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) { }
          listOfAttrsets;
  __subnet = lib: ip:
    (builtins.concatStringsSep "."
      (lib.lists.take 3 (lib.strings.splitString "." ip)));

      #evaluates to sth like "0" = { "1" = ["0.1" "host"];};
  reverse_map_add_path_to_value = with lib; set:( mapAttrsRecursive (path: value: [value (concatStringsSep "." path) ]) set);
  #evaluates from "0" = { "1" = ["0.1" "host"];}; -> [["0.1" "host"]]
  flatten_attrs_list = with lib; set: collect isList (reverse_map_add_path_to_value set);

  attrs_from_list = with lib; list: listToAttrs (map (ip_name: {name = (head ip_name); value = (last ip_name);}) list);

  #evalutes to "host.interface" = "0.1";
  reverse_map_interim = with lib.lists; set:  attrs_from_list (flatten_attrs_list set);

  split_string_once_back = str:
    let arr = lib.splitString "%" str;
    in [(lib.concatStrings (lib.reverseList (lib.tail (lib.reverseList arr)))) (lib.last arr)];

  reverse_map = set: recursiveMerge (lib.map(name_value:
  let
    split = split_string_once_back name_value.name;
    name = lib.head split;
    name_2 = lib.last split;
  in {
    "${name}"."${name_2}" = name_value.value;
  }
  ) (lib.attrsToList (reverse_map_interim set)));
in {
  ip_cidr = ip: "${ip}/32";
  subnet_cidr = lib: ip: let subnet = (__subnet lib ip); in "${subnet}.0/24";


} //
    reverse_map {
      "192.168" = {
        #local wohnheim
        "0" = {
          #this is dumb!!! I actually have DHCP configured determine which is better...
          "13" = "pve%vmbr0";
          "15" = "porta%ens3";
          "23" = "syncschlawiner%ens3";
          "27" = "syncschlawiner_mkhh%ens3";
          "25" = "tabula%ens3";
          "26" = "grapheum%ens3";
        };

        #vpn endpoints
          #commit to naming scheme:
          # - 0xx for servers
          # - 1(0-4)x for workstations
          # - 1(5-9)x mobiles
          # - 2xx for reserved
        "1" = {
          "3" = "welt%wg0";
          "4" = "porta%wg0";
          "11" = "hermes%wg0";
          "5" = "syncschlawiner%wg0";
          "9" = "syncschlawiner_mkhh%wg0";
          "6" = "thinkpad%wg0";
          "16" = "thinknew%wg0";
          "17" = "yoga%wg0";
          "10" = "mainpc%wg0";
          "7" = "handy_hannses%wg0";
          "8" = "tabula%wg0";
        };

      };

      "127.0" = {
        "1" = {
          #vm subnet
          # naming scheme:
          # 1-9  - internal
          "1" = "vm-bridge.host";

          # others - any vm
          "10" = "vm-bridge.fons";
        };
      };

      "57.129.6.13" = "welt%ens3"; #DO NOT USE THIS USE THE DOMAIN INSTEAD
    }

#{
#  pve = { vmbr0 = "192.168.0.13"; };
#  welt = {
#    ens3 = "57.129.6.13";
#    wg0 = "192.168.1.3";
#  };
#  porta = {
#    ens18 = "192.168.0.15";
#    wg0 = "192.168.1.4";
#  };
#  hermes.wg0 = "192.168.1.11";
#  syncschlawiner = {
#    wg0 = "192.168.1.5";
#    ens0 = "192.168.0.23";
#  };
#  syncschlawiner_mkhh = {
#    wg0 = "192.168.1.9";
#    ens0 = "192.168.0.27";
#  };
#  thinkpad.wg0 = "192.168.1.6";
#  thinknew.wg0 = "192.168.1.16";
#  yoga.wg0 = "192.168.1.17";
#  mainpc.wg0 = "192.168.1.10";
#  handy_hannses.wg0 = "192.168.1.7";
#  tabula = {
#    wg0 = "192.168.1.8";
#    ens0 = "192.168.0.25";
#  };
#  grapheum = { ens0 = "192.168.0.26"; };
#}
