{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe';
  hyprctl = getExe' config.wayland.windowManager.hyprland.package "hyprctl";
  disable_ext_monitors = pkgs.writers.writeNuBin "disable_ext_monitors" /* nu */ ''
    def disable_ext_monitors [] {
      let monitors = (${hyprctl} monitors -j)
      print $monitors
      let ext_monitors =  $monitors | from json | where { |e| $e.name != "eDP-1"}
      for m in $ext_monitors {
        print "disabling monitor" $m.name
        run-external "${hyprctl}" "keyword" "monitor" $"($m.name),disable"
      }
    }
    disable_ext_monitors 
  '';
in
{
  options.my.desktop.monitors.enable = mkEnableOption "monitors" // {
    default = config.my.desktop.hyprland.enable;
  };
  config = mkIf config.my.desktop.monitors.enable {
    home.packages = with pkgs; [
      wlr-randr
      wdisplays # gui display positioning
      disable_ext_monitors
    ];
  };
}
