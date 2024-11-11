{ lib, config, pkgs, ... }:
let
  inherit (lib)
    mapAttrsToList concatStringsSep hasPrefix partition naturalSort reverseList
    flatten;
  _split_delim = "/";
  ips = config.ips.ips.ips.default;
  ips_list = flatten (mapAttrsToList (hostname: interfaces:
    mapAttrsToList (if_name: if_ip:
      "${hostname}${_split_delim}${if_name}${_split_delim}${if_ip}") interfaces)
    ips);
  ips_file = pkgs.writeText "ips_file" ((concatStringsSep "\n") ips_list);

  ips_app = pkgs.writeShellApplication {
    name = "ips";
    checkPhase = ":"; # too many failed checks
    bashOptions = [ ]; # unbound variable $1
    text = ''
      all=$(cat ${ips_file})
      echo "$all" | column -s${_split_delim} -t --table-noheadings --table-columns HOSTNAME,INTERFACE,PORT --table-right PORT | ${pkgs.fzf}/bin/fzf | awk '{print $NF}' | wl-copy
    '';
  };
in {

  environment.systemPackages = [ ips_app ];
}
