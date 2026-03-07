{
  pkgs,
  lib,
  scripts,
  ...
}:
lib.filter (a: a != "") (
  lib.splitString "\n" ''
    [workspace special:browser silent] ${pkgs.firefox}/bin/firefox
    [workspace special:music silent] ${pkgs.firefox}/bin/firefox -P spotify
    [workspace special:passwords silent] ${pkgs.keepassxc}/bin/keepassxc
    [workspace 9 silent] ${pkgs.signal-desktop}/bin/signal-desktop
    [workspace 10 silent] ${pkgs.thunderbird}/bin/thunderbird
  ''
)
