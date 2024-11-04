{ lib, config, pkgs, ... }:

let
  inherit (lib)
    mapAttrsToList concatStringsSep hasPrefix partition naturalSort reverseList
    flatten;
  _split_delim = "/";
  _ports = config.ports.ports;
  ports_list = ports:
    mapAttrsToList (n: v: "${n}${_split_delim}${toString v.port}") ports;

  all_ports_flattened = flatten (mapAttrsToList
    (hostname: portattrs: map (v: "${hostname}/${v}") (ports_sorted portattrs))
    _ports.flattened);

  ports_partition = ports: partition (v: hasPrefix "ssh." v) (ports_list ports);

  ports_sorted = ports:
    reverseList ((naturalSort (ports_partition ports).right)
      ++ (naturalSort (ports_partition ports).wrong));
  all_ports_sorted = naturalSort all_ports_flattened;
  curr_ports_sorted = (ports_sorted _ports.curr_flattened);

  ports_file = ports:
    pkgs.writeText "ports_file" ((concatStringsSep "\n") ports);

  common_ports_app_prelude = ports: ''
    ssh=0
    hostname=""
    for (( i=1; i<=$#; i++)); do
        case "''${!i}" in
          "-s") ssh=1;;
          (*) hostname=''${!i};;
        esac
    done
    all=$(cat ${ports_file ports})
  '';

  curr_ports_app = pkgs.writeShellApplication {
    name = "curr_ports";
    checkPhase = ":"; # too many failed checks
    bashOptions = [ ]; # unbound variable $1
    text = ''
      ${common_ports_app_prelude curr_ports_sorted}
      if [[ "$ssh" -eq 1 ]]; then
        all=$(echo "$all" | grep -E "^ssh\\.")
      fi
      echo "$all" | column -s${_split_delim} -t --table-noheadings --table-columns SERVICE,PORT --table-right PORT | ${pkgs.fzf}/bin/fzf
    '';
  };
  all_ports_app = pkgs.writeShellApplication {
    name = "all_ports";
    checkPhase = ":"; # too many failed checks
    bashOptions = [ ]; # unbound variable $1
    text = ''
      ${common_ports_app_prelude all_ports_sorted}
      if [[ "$ssh" -eq 1 ]]; then
        all=$(echo "$all" | grep -E "^[[:alnum:]]*/ssh\.")
      fi
      if [[ "$hostname" != "" ]]; then
      all=$(echo "$all" | grep -E "^$hostname/")
      fi
      echo "$all" | column -s${_split_delim} -t --table-noheadings --table-columns HOST,SERVICE,PORT --table-right PORT | ${pkgs.fzf}/bin/fzf
    '';
  };
in {
  # extract to IPorts.nix
  environment.systemPackages = [ curr_ports_app all_ports_app ];
}
