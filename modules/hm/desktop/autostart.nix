{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) attrsOf listOf str;
in
{
  options.my.desktop.autostart = {
    enable = mkEnableOption "autostart" // {
      default = config.my.desktop.enable;
    };
    autostart = mkOption {
      type = attrsOf (attrsOf (listOf str));
      description = ''
        Programs to launch at startup, grouped by workspace and layout.

        Each key is a workspace (e.g. "1" or "special:browser"), each value a
        layout ("tabbed", "splitv", "splith", ...) mapping to the list of
        commands to run in that layout. Layouts are honored by WMs that support
        per-workspace layouts (sway); hyprland uses the workspace placement
        only.
      '';
      default = { };
    };

  };
  config = mkIf config.my.desktop.autostart.enable {
    my.desktop.autostart.autostart = {
      "special:browser" = {
        tabbed = [ "${pkgs.firefox}/bin/firefox" ];
      };
      "special:passwords" = {
        tabbed = [ "${pkgs.keepassxc}/bin/keepassxc" ];
      };
      "9" = {
        tabbed = [ "${pkgs.signal-desktop}/bin/signal-desktop" ];
      };
      "10" = {
        tabbed = [ "${pkgs.thunderbird}/bin/thunderbird" ];
      };
    };
  };
}