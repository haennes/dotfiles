{lib, ...}:
let
  recursiveMerge = listOfAttrsets:
          lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) { }
          listOfAttrsets;
  #evaluates to sth like "8" = { "384" = ["8384" "host"];};
  reverse_map_add_path_to_value = with lib; set:( mapAttrsRecursive (path: value: [value (concatStringsSep "" path) ]) set);

  #evaluates from "8" = { "384" = ["8384" "host"];}; -> [["8384" "host"]]
  flatten_attrs_list = with lib; set: collect isList (reverse_map_add_path_to_value set);

  attrs_from_list = with lib; list: recursiveMerge (map (name_ip: setAttrByPath (splitString "." (head name_ip)) (last name_ip)) list);
  #setAttrByPath

  #evalutes to a.b = 001;
  reverse_map = with lib.lists; set:
  lib.mapAttrsRecursive(name: value: if (lib.isString value) then (lib.toInt value) else value)
  (attrs_from_list (flatten_attrs_list set));

  #reverse_map = with lib; set: mapAttrs' (name: value: {name = lists.head value; value = lists.tail value;}) ( ( mapAttrsRecursive (path: value: (concatStringsSep "" path) ++ [value]) set));
  common = {
    "51821" = "wg0";
    "8384" = "syncthing.gui"; #not all run syncthing,but never use port for sth different
  };
  headfull = {
    "8385" = "ssh.syncschlawiner.syncthing.gui";
    "8386" = "ssh.syncschlawiner.80"; #IS THIS NC?
    "8006" = "ssh.proxmox.gui";
    "8387" = "ssh.syncschlawiner.443"; #IS THIS NC?
    "8388" = "ssh.tabula.syncthing.gui";
    "8389" = "ssh.tabula.443";
    "8390" = "ssh.tabula.80";
    "9090" = "ssh.syncschlawiner.8081"; #WTF is this????

    "20002" = "autossh-monitoring.syncschlawiner";
    "20000" = "autossh-monitoring.pve";
  };
in
#do note that value takes precedence
lib.mapAttrs'(name: value: {inherit name; value = reverse_map (common // value);})
{
  # could also be ${config.syncthing}
  yoga = headfull;
  thinkpad = headfull;
  thinknew = headfull;
  mainpc = headfull;

  syncschlawiner = {
    "8081" = "ipfs.api";
    "80" = "nextcloud.web";
    "8001" = "kasmweb.gui";
    "8384" = "syncthing.gui";
  };
  syncschlawiner_mkhh = { };
  tabula = { };
  porta = { };
  welt = { };


#scheme:
  #hostname.port = "service"
  #decided to not encourage allow hostname.digit.rest = "service" as it gets to confusing
}

