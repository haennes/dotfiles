{ pkgs, lib, scripts, ... }:
lib.filter (a: a != "") (lib.splitString "\n" ''
  ${pkgs.wpaperd}/bin/wpaperd
  [workspace 2 silent] ${pkgs.firefox}/bin/firefox
  [workspace 7 silent] ${pkgs.firefox}/bin/firefox --new-windows spotify.com
  [workspace 8 silent] ${pkgs.keepassxc}/bin/keepassxc
  [workspace 9 silent] ${pkgs.signal-desktop}/bin/signal-desktop
  [workspace 9 silent] ${scripts.iamb}
  [workspace 10 silent] ${pkgs.thunderbird}/bin/thunderbird
'')

