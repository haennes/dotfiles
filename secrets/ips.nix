{ lib, ... }:
let
  recursiveMerge = listOfAttrsets:
    lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) { } listOfAttrsets;
  __subnet = lib: ip:
    (builtins.concatStringsSep "."
      (lib.lists.take 3 (lib.strings.splitString "." ip)));

  #evaluates to sth like "0" = { "1" = ["0.1" "host"];};
  reverse_map_add_path_to_value = with lib;
    set:
    (mapAttrsRecursive (path: value: [ value (concatStringsSep "." path) ])
      set);
  #evaluates from "0" = { "1" = ["0.1" "host"];}; -> [["0.1" "host"]]
  flatten_attrs_list = with lib;
    set:
    collect isList (reverse_map_add_path_to_value set);

  attrs_from_list = with lib;
    list:
    listToAttrs (map (ip_name: {
      name = (head ip_name);
      value = (last ip_name);
    }) list);

  #evalutes to "host.interface" = "0.1";
  reverse_map_interim = with lib.lists;
    set:
    attrs_from_list (flatten_attrs_list set);

  split_string_once_back = str:
    let arr = lib.splitString "%" str;
    in [
      (lib.concatStrings (lib.reverseList (lib.tail (lib.reverseList arr))))
      (lib.last arr)
    ];

  reverse_map = set:
    recursiveMerge (lib.map (name_value:
      let
        split = split_string_once_back name_value.name;
        name = lib.head split;
        name_2 = lib.last split;
      in { "${name}"."${name_2}" = name_value.value; })
      (lib.attrsToList (reverse_map_interim set)));
in {
  ip_cidr = ip: "${ip}/32";
  subnet_cidr = lib: ip: let subnet = (__subnet lib ip); in "${subnet}.0/24";
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

} // reverse_map {
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
      "10" = "deus%wg0";
      "7" = "handy_hannses%wg0";
      "8" = "tabula%wg0";
    };

    "3" = {
      #vm subnet
      # naming scheme:
      # 1-9  - internal
      "1" = "vm-host%virbr0";

      # others - any vm
      "10" = "vm-fons%virbr0";
    };

  };

  "57.129.6.13" = "welt%ens3"; # DO NOT USE THIS USE THE DOMAIN INSTEAD
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
