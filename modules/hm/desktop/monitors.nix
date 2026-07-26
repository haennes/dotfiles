{
  config,
  osConfig,
  lib,
  pkgs,
  inputs,
  globals,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    attrValues
    mapAttrs
    getExe'
    mkOption
    types
    ;
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
  hlib = inputs.haumea.lib;
  nushellsave =
    pkgs.writers.writeNuBin "save-monitor-config"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [ pkgs.wlr-randr ]}"
        ];
      }
      ''
        let randrop = (wlr-randr --json | from json)
        let proname = ($randrop | sort-by name | select make model name | each {|e| $e.make + $e.model + $e.name }| reduce { |it, acc| $it + "_" + $acc })
        def mkUnkown [a] {
          if $a == null {
            "Unknown"
          } else {
            $a
          }
        }
        let _ = { 
          proname: {
            outputs: ($randrop | flatten modes
              | where modes.current 
              | insert criteria { |r| $"(mkUnkown $r.make) (mkUnkown $r.model) (mkUnkown $r.serial)" }
              | select adaptive_sync modes position scale transform criteria
              | rename --column {adaptive_sync: adaptiveSync, modes: mode}
              | update position {|p| 
                let pos = ($p.position)
                $"($pos.x),($pos.y)"
              }
              | update mode {|m| $"($m.mode.width)x($m.mode.height)"}  
              | to json
              | each {|e| $"\'\'\n($e)\'\'"} 
              | save -f $"${globals.dotfiles_path}/modules/hm/desktop/monitor-profiles/$($proname).nix"
            )
          }
        }
      '';
in
{
  options.my.desktop.monitors = {
    enable = mkEnableOption "monitors" // {
      default = config.my.desktop.hyprland.enable;
    };
    save-config = mkOption {
      description = "save config package";
      type = types.package;
      default = nushellsave;
    };
    builtin = mkOption{
      type = types.str;
      default = osConfig.my.desktop.monitors.builtin;
    };
  };
  config = mkIf config.my.desktop.monitors.enable {
    home.packages = with pkgs; [
      wlr-randr
      wdisplays # gui display positioning
      disable_ext_monitors
      config.my.desktop.monitors.save-config
    ];
    services.kanshi = {
      enable = true;
      settings = attrValues (
        mapAttrs
          (_: v: {
            profile.outputs = builtins.fromJSON v;
          })
          (
            hlib.load {
              src = ./monitor-profiles;
              loader = hlib.loaders.default;
              inputs = { };
            }
          )
      );
    };
  };
}
