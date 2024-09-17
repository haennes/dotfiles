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
    (mapAttrsRecursive (path: value: [ value (concatStringsSep ":" path) ])
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
in reverse_map {
  #private mac "subnet"
  #https://en.wikipedia.org/wiki/MAC_address#IEEE_802c_local_MAC_address_usage
  "02" = {
    # use for vms
    "01" = { "00:00:00:01" = "vm-fons%eth0"; };
  };
}
