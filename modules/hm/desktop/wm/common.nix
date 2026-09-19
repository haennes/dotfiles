# Home Manager module declaring the shared window manager configuration.
#
# Consumed by `modules/hm/desktop/sway.nix` (and, in the future, hyprland.nix).
# The values are derived from the per-user `scripts`/`globals`/`theme` args.
{
  config,
  lib,
  pkgs,
  scripts,
  globals,
  theme,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  actions = import ./actions.nix {
    inherit config lib pkgs;
  };
  bindle = actions.lockedRepeat;
in
{
  options.my.desktop.wm.common = {
    enable = mkEnableOption "shared window manager config" // {
      default = config.my.desktop.sway.enable;
    };

    normalWorkspaces = mkOption {
      type = types.listOf types.str;
      default = map toString (lib.lists.range 1 10);
      description = ''
        Normal workspaces cycled by workspace-next/prev. Special workspaces
        (specialWorkspaces) are skipped.
      '';
      readOnly = true;
    };

    variables = mkOption {
      type = types.attrsOf types.str;
      readOnly = true;
    };

    visuals = mkOption {
      type = types.attrs;
      readOnly = true;
    };

    specialWorkspaces = mkOption {
      type = types.attrsOf types.str;
      description = ''
        Special workspaces. Each key is a workspace name, each value the
        shell command that hosts that workspace's app. Hyprland toggles them
        with `togglespecialworkspace`; sway toggles them via the
        workspace-toggle script (see modules/hm/desktop/sway.nix) and
        workspace-next/prev skip them.
      '';
      readOnly = true;
    };

    bindings = mkOption {
      type = types.attrsOf types.attrs;
      readOnly = true;
    };

    submaps = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          entry = mkOption {
            type = types.str;
          };
          binds = mkOption {
            type = types.attrsOf types.attrs;
          };
        };
      });
      readOnly = true;
    };
  };

  config = mkIf config.my.desktop.wm.common.enable {
    my.desktop.wm.common.variables = {
      "$mod" = "SUPER";
      "$terminal" = "${globals.term}";
      "$runprompt" = "${scripts.selector}";
      "$volume" = "${scripts.volume}";
      "$brightness" = "${scripts.brightness}";
      "$sccpa" = "${scripts.screenshot-fast}";
    };

    my.desktop.wm.common.visuals = {
      gaps = {
        inner = 5;
        outer = 10;
      };
      border = {
        size = 2;
        active = "#${theme.color_first}";
        active2 = "#${theme.color_second}";
        inactive = "#${theme.background}";
      };
      rounding = 10;
      opacities = {
        active = 0.9;
        inactive = 0.75;
        fullscreen = 1.0;
      };
      blur = {
        enable = true;
        radius = 5;
        passes = 3;
      };
    };

    my.desktop.wm.common.specialWorkspaces = {
      keepassxc = "keepassxc";
      web = globals.browser;
      tasks = "${globals.execute_term} --class tasks";
      chat = "element-desktop";
    };

    my.desktop.wm.common.bindings = {
      # special workspaces (hyprland: togglespecialworkspace; sway: toggle script)
      "mod+b" = actions.specialToggle "web";
      "mod+t" = actions.specialToggle "tasks";
      "mod+m" = actions.specialToggle "chat";

      # apps
      "mod+Return" = actions.exec globals.term;
      "Ctrl+space" = actions.exec scripts.selector;
      "mod+v" = actions.exec scripts.clipboard;

      # kill window / exit
      "mod+Q" = actions.kill;
      "mod+Shift+Ctrl+Q" = actions.quit;

      # lock
      "mod+Shift+L" = actions.lock;

      # focus movement (hjkl) + workspace cycling (arrows skip specials)
      "mod+arrow_l" = actions.workspaceRel (-1);
      "mod+h" = actions.focus "l";
      "mod+arrow_r" = actions.workspaceRel 1;
      "mod+l" = actions.focus "r";
      "mod+arrow_u" = actions.focus "u";
      "mod+k" = actions.focus "u";
      "mod+arrow_d" = actions.focus "d";
      "mod+j" = actions.focus "d";

      # workspaces
      "mod+o" = actions.workspaceRel 1;
      "mod+u" = actions.workspaceRel (-1);
      "mod+1" = actions.workspace 1;
      "mod+2" = actions.workspace 2;
      "mod+3" = actions.workspace 3;
      "mod+4" = actions.workspace 4;
      "mod+5" = actions.workspace 5;
      "mod+6" = actions.workspace 6;
      "mod+7" = actions.workspace 7;
      "mod+8" = actions.workspace 8;
      "mod+9" = actions.workspace 9;
      "mod+0" = actions.workspace 10;

      # move window to workspace
      "mod+Shift+1" = actions.moveToWorkspace 1;
      "mod+Shift+2" = actions.moveToWorkspace 2;
      "mod+Shift+3" = actions.moveToWorkspace 3;
      "mod+Shift+4" = actions.moveToWorkspace 4;
      "mod+Shift+5" = actions.moveToWorkspace 5;
      "mod+Shift+6" = actions.moveToWorkspace 6;
      "mod+Shift+7" = actions.moveToWorkspace 7;
      "mod+Shift+8" = actions.moveToWorkspace 8;
      "mod+Shift+9" = actions.moveToWorkspace 9;
      "mod+Shift+0" = actions.moveToWorkspace 10;

      # window state
      "mod+M" = actions.fullscreen;
      "mod+Ctrl+M" = actions.maximize;
      "mod+F" = actions.toggleFloat;

      # monitors
      "mod+period" = actions.switchMonitor 1;
      "mod+comma" = actions.switchMonitor (-1);
      "mod+Shift+period" = actions.workspaceToOutputRel 1;
      "mod+Shift+comma" = actions.workspaceToOutputRel (-1);
      "mod+Shift+P" = actions.workspaceToOutputRel 1;

      # scroll through workspaces
      "mod+mouse_wheel_down" = actions.workspaceRel 1;
      "mod+mouse_wheel_up" = actions.workspaceRel (-1);

      # volume
      "XF86AudioRaiseVolume" = bindle (actions.exec "${scripts.volume} -i");
      "XF86AudioLowerVolume" = bindle (actions.exec "${scripts.volume} -d");
      "XF86AudioMute" = bindle (actions.exec "${scripts.volume} -t");
      "XF86AudioMicMute" = bindle (actions.exec "${scripts.volume} -m");
      "XF86AudioPlay" = bindle (actions.exec "playerctl play-pause");
      "XF86AudioPause" = bindle (actions.exec "playerctl play-pause");
      "XF86AudioNext" = bindle (actions.exec "playerctl next");
      "XF86AudioPrev" = bindle (actions.exec "playerctl previous");

      # brightness
      "XF86MonBrightnessUp" = bindle (actions.exec "${scripts.brightness} -i");
      "XF86MonBrightnessDown" = bindle (actions.exec "${scripts.brightness} -d");

      # layout / screenshot
      "mod+P" = actions.toggleSplit;
      "mod+Shift+S" = actions.exec scripts.screenshot-fast;
    };

    my.desktop.wm.common.submaps = {
      resize = {
        entry = "mod+R";
        binds = {
          "arrow_l" = actions.repeat (actions.resizeAxis "w" (-10));
          "h" = actions.repeat (actions.resizeAxis "w" (-10));
          "arrow_r" = actions.repeat (actions.resizeAxis "w" 10);
          "l" = actions.repeat (actions.resizeAxis "w" 10);
          "arrow_u" = actions.repeat (actions.resizeAxis "h" (-10));
          "k" = actions.repeat (actions.resizeAxis "h" (-10));
          "arrow_d" = actions.repeat (actions.resizeAxis "h" 10);
          "j" = actions.repeat (actions.resizeAxis "h" 10);
          "escape" = actions.reset;
          "return" = actions.reset;
        };
      };
      move = {
        entry = "mod+Shift+M";
        binds = {
          "arrow_l" = actions.repeat (actions.moveDir "l");
          "h" = actions.repeat (actions.moveDir "l");
          "arrow_r" = actions.repeat (actions.moveDir "r");
          "l" = actions.repeat (actions.moveDir "r");
          "arrow_u" = actions.repeat (actions.moveDir "u");
          "k" = actions.repeat (actions.moveDir "u");
          "arrow_d" = actions.repeat (actions.moveDir "d");
          "j" = actions.repeat (actions.moveDir "d");
          "escape" = actions.reset;
          "return" = actions.reset;
        };
      };
      swap = {
        entry = "mod+S";
        binds = {
          "arrow_l" = actions.repeat (actions.swapDir "l");
          "h" = actions.repeat (actions.swapDir "l");
          "arrow_r" = actions.repeat (actions.swapDir "r");
          "l" = actions.repeat (actions.swapDir "r");
          "arrow_u" = actions.repeat (actions.swapDir "u");
          "k" = actions.repeat (actions.swapDir "u");
          "arrow_d" = actions.repeat (actions.swapDir "d");
          "j" = actions.repeat (actions.swapDir "d");
          "escape" = actions.reset;
          "return" = actions.reset;
        };
      };
    };
  };
}
