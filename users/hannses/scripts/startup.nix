{
  pkgs,
  lib,
  ...
}:
let
  starts = {
    "special:browser" = "${pkgs.firefox}/bin/firefox";
    "special:music" = "${pkgs.firefox}/bin/firefox -P spotify";
    "special:passwords" = "${pkgs.keepassxc}/bin/keepassxc";
    "9" = "${pkgs.signal-desktop}/bin/signal-desktop";
    "10" = "${pkgs.thunderbird}/bin/thunderbird";
  };
in
lib.imap0 (
  i: nv: "[workspace ${nv.name} silent] sleep ${lib.toString (1 + 2 * i)}s && ${nv.value}"
) (lib.mapAttrsToList lib.nameValuePair starts)
# lib.filter (a: a != "") (
#   lib.splitString "\n" ''
#     [workspace special:browser silent] ${pkgs.firefox}/bin/firefox
#     [workspace special:music silent] ${pkgs.firefox}/bin/firefox -P spotify
#     [workspace special:passwords silent] ${pkgs.keepassxc}/bin/keepassxc
#     [workspace 9 silent] ${pkgs.signal-desktop}/bin/signal-desktop
#     [workspace 10 silent] ${pkgs.thunderbird}/bin/thunderbird
#   ''
# )
