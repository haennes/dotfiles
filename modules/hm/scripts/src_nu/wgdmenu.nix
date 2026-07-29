{globals, pkgs, lib, wg-friendly-peer-names, ...}:
let
  inherit (lib) getExe' getExe;
  inherit (pkgs.stdenv.hostPlatform) system;
  systemctl = getExe' pkgs.systemd "systemctl";
  sudo = getExe pkgs.sudo;
  wgg = "/run/wrappers/bin/wgg";
in
''
def wgg [] {
  return (^${wgg} -f json | from json)
}

def rofi [choose: list<string>] {
  return ($choose | str join "\n" | ^${globals.dmenu})
}

def fmt_peer [peer] {
  let last = $peer.stats.last_handshake_time;
  let symbol = if last == null {
    "🔵"
  } else {
     let delta = ((date now | into int) / (10 ** 9)) - ($last.secs_since_epoch | first );
     if $delta < 150 {
      "🟢"
    } else {
      "🟡"
    }
  }
  return $"($symbol) ($peer.name | first)"
}

def rofi_systemd_action [service: string, action: string] {
   let old = $env.SUDO_ASKPASS?;
   let progfile = mktemp --dry
   $env.SUDO_ASKPASS = $progfile
   r##'#!/usr/bin/env sh
   ${globals.dmenu} -disable-history -password -p "Sudo Password: "
   '## | save -f $progfile
   chmod +x $progfile
   ${sudo} -A ${systemctl} $action $service
   rm $progfile
   $env.SUDO_ASKPASS = $old;
}

let keys = (wgg | each {|e| $e.name})
let wgif = rofi $keys
if wgif != "" and $wgif in $keys {
  let curr_if = (wgg | where name == $wgif)
  let actions = [ "stop" "start" "restart" ] 
  let action_or_peer = rofi (($actions ++ ($curr_if.peers | each {|e| fmt_peer $e }) ) | flatten)

  print $action_or_peer
  if $action_or_peer == "" {
    return
  } else {
    if $action_or_peer in $actions {
      rofi_systemd_action $"wireguard-($curr_if.name | first).target" $action_or_peer
    } else {
      let curr_peer = ($action_or_peer | split row " " -n 2).1;
      print $curr_peer
      let actions = ["stop" "start" "restart"]
      let action = rofi $actions;
      if action == "" {
        return
      }
      rofi_systemd_action $"wireguard-($curr_if.name | first)-peer-($curr_peer).service" $action
    }
  }
}
''
