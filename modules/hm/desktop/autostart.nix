{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types)
    listOf
    submodule
    str
    nullOr
    ;
in
{
  options.my.desktop.autostart = {
    enable = mkEnableOption "gnome" // {
      default = config.my.desktop.enable;
    };
    autostart = mkOption {
      type = listOf (submodule {
        options = {
          desktop = mkOption {
            type = nullOr str;
          };
          cmd = mkOption {
            type = str;
          };
        };
      });
      default = [ ];
    };

  };
  config =
    let
      inherit (lib) mapAttrsToList;
      start = {
        "special:browser" = "${pkgs.firefox}/bin/firefox";
        "special:passwords" = "${pkgs.keepassxc}/bin/keepassxc";
        "9" = "${pkgs.signal-desktop}/bin/signal-desktop";
        "10" = "${pkgs.thunderbird}/bin/thunderbird";
      };
    in
    mkIf config.my.desktop.autostart.enable {
      my.desktop.autostart.autostart = mapAttrsToList (desktop: cmd: {
        inherit desktop cmd;
      }) start;

    };
}
