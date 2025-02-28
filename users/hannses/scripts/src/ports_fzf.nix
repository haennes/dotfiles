{ globals, pkgs, scripts, lib, config, ... }:
let
  inherit (lib)
    removeAttrs attrNames mapAttrs concatLines concatStringsSep
    mapAttrsRecursive mapAttrsToList listToAttrs collect isList flatten;
  inherit (lib.my) flatten_attrs;
  inherit (config.ports.ports) curr_ports;
  _split_delim = "/";
  curr_ports_no_ssh = flatten_attrs (removeAttrs curr_ports [ "ssh" ]);
  curr_ssh_ports = mapAttrs (n: v: flatten_attrs v) curr_ports.ssh;

  mapPortsToString = v:
    concatLines
    (mapAttrsToList (ni: vi: "${ni}${_split_delim}${toString vi}") v);
  curr_ports_no_ssh_file =
    pkgs.writeText "ports-nossh" (mapPortsToString curr_ports_no_ssh);
  curr_ssh_ports_files =
    mapAttrs (n: v: pkgs.writeText "ports-ssh-${n}" (mapPortsToString v))
    curr_ssh_ports;
  curr_ssh_ports_file_toplevel =
    let list = mapAttrsToList (n: v: "ln -s ${v} ${n}") curr_ssh_ports_files;
    in pkgs.runCommand "ports-ssh" { } ''
      mkdir -p $out
      cd $out
      ${concatLines list}
    '';
  firefox_bin = "${pkgs.firefox}/bin/firefox";

in ''
  DMENU="${globals.dmenu}"
  kind=$( \
    echo "${concatLines [ "local" "ssh" ]}" \
    | $DMENU)
  case $kind in
    ssh)
      hosts="${concatLines (attrNames curr_ssh_ports)}"
      DMENU="$DMENU -window-title"
      host=$(echo -e "$hosts" | $DMENU "ssh")
      selection=$(cat ${curr_ssh_ports_file_toplevel}/$host | $DMENU "$host")
    ;;
    local)
      selection=$(cat ${curr_ports_no_ssh_file} | $DMENU )
    ;;
  esac
  port=$(echo $selection | cut -d'${_split_delim}' -f2)
  domain=$(echo $selection | cut -d'${_split_delim}' -f1 | tr '.' '\n' | tac | xargs echo -n | tr ' ' '.')
  if [[ "$kind" == "ssh" ]] then
    domain=$domain.$host.ssh
  fi
  action=$(echo "${
    concatLines [ "open browser domain" "open browser port" "copy port" ]
  }" | $DMENU "action")
  case $action in
    "open browser domain")
      ${firefox_bin} http://"$domain".ports.localhost
    ;;
    "open browser port")
      ${firefox_bin} http://localhost:$port
    ;;
    "copy port")
      echo $port | ${pkgs.wl-clipboard}/bin/wl-copy
    ;;
  esac

''
