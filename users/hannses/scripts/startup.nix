{ pkgs, lib, ... }:
lib.filter (a: a != "") (lib.splitString "\n"
  #pkgs.pkgs.writeShellScript "startup"
  ''
    ${pkgs.waybar}/bin/waybar
    ${pkgs.wpaperd}/bin/wpaperd
    [workspace 2 silent] ${pkgs.firefox}/bin/firefox
    [workspace 8 silent] ${pkgs.keepassxc}/bin/keepassxc
    [workspace 9 silent] ${pkgs.signal-desktop}/bin/signal-desktop
    [workspace 9 silent] ${pkgs.element-desktop}/bin/element-desktop
    [workspace 10 silent] ${pkgs.thunderbird}/bin/thunderbird
  '')

