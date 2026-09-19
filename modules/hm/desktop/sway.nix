# Home Manager SwayFX config, fully derived from the shared WM spec
# (modules/hm/desktop/wm/common.nix). The special-workspace and workspace
# cycling logic lives in modules/hm/desktop/wm/actions.nix.
{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  common = config.my.desktop.wm.common;
  keys = import ./wm/keys.nix {
    inherit lib;
  };
  render = import ./wm/render.nix {
    inherit lib keys;
  };

  # sway binds keysyms by their ASCII keysym name, so unicode keys from the
  # shared spec (e.g. "ö") must be normalized to their keysym here.
  swayKeysym = {
    "ö" = "odiaeresis";
  };
  normalizeCombo = combo:
    lib.replaceStrings (lib.attrNames swayKeysym) (lib.attrValues swayKeysym) combo;
  normalizeKeysyms = lib.mapAttrs' (name: value: lib.nameValuePair (normalizeCombo name) value);
in
{
  options.my.desktop.sway.enable = mkEnableOption "sway" // {
    default = config.my.desktop.enable;
  };

  config = mkIf config.my.desktop.sway.enable {
    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
      systemd.enable = true;
      checkConfig = false;

      config =
        let
          # HM sway ships default keybindings (mkOptionDefault) with no
          # hyprland equivalent; null them so sway has exactly the shared spec.
          noSwayDefault = {
            "Mod4+Shift+q" = null; # kill (spec: Mod4+q)
            "Mod4+d" = null; # dmenu (spec: Ctrl+space)
            "Mod4+v" = null; # splitv
            "Mod4+a" = null; # focus parent
            "Mod4+s" = null; # layout stacking
            "Mod4+w" = null; # layout tabbed
            "Mod4+e" = null; # layout toggle split (spec: Mod4+p)
            "Mod4+Shift+h" = null; # move window (spec: submaps)
            "Mod4+Shift+j" = null;
            "Mod4+Shift+k" = null;
            "Mod4+Shift+l" = null;
            "Mod4+Shift+Left" = null;
            "Mod4+Shift+Down" = null;
            "Mod4+Shift+Up" = null;
            "Mod4+Shift+Right" = null;
            "Mod4+minus" = null; # scratchpad show (spec: mod+space)
            "Mod4+Shift+minus" = null; # move scratchpad (spec: mod+Shift+space)
            "Mod4+Shift+c" = null; # reload
            "Mod4+Shift+e" = null; # swaynag exit
          };
        in
        {
          modifier = "Mod4";

          keybindings = noSwayDefault // normalizeKeysyms (render.sway.keybindings common.bindings common.submaps) // {
            "Mod4+p" = "mode layout";
          };
          modes = lib.mapAttrs (_: normalizeKeysyms) (render.sway.modes common.submaps) // {
            "layout" = {
              "Escape" = "mode default";
              "Return" = "mode default";
              "p" = "focus parent";
              "n" = "focus child";
              "h" = "focus left";
              "j" = "focus down";
              "k" = "focus up";
              "l" = "focus right";

              "f" = "floating toggle";

              "t" = "layout tabbed";
              "s" = "layout stacking";

              "v" = "layout splitv";
              "Shift+v" = "splitv";
              "c" = "layout splith";
              "Shift+c" = "splith";

              "x" = "layout toggle split";
              "y" = "layout toggle all";
            };
          };

          input = {
            "type:keyboard" = {
              xkb_layout = "de,us,eu";
              xkb_options = "caps:escape";
            };
            "type:touchpad" = {
              natural_scroll = "enabled";
              dwt = "enabled";
              drag_lock = "enabled";
              tap = "enabled";
            };
            "type:tablet" = {
              map_to_output = config.my.desktop.monitors.builtin;
            };
          };
          startup = [
            {
              command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK && systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK";
            }
          ];

          window = {
            titlebar = false;
            border = common.visuals.border.size;
            commands = [
              # windows start tiled by default, even when their app asks to float.
              # app_id matches native Wayland windows only, class matches XWayland.
            ];
          };

          floating = {
            titlebar = false;
            border = common.visuals.border.size;
            modifier = "Mod4";
          };

          gaps = common.visuals.gaps;

          colors = {
            background = "#${theme.background}";
            focused = {
              border = "#${theme.color_first}";
              background = "#${theme.color_first}";
              text = "#ffffff";
              indicator = "#${theme.color_first}";
              childBorder = "#${theme.color_first}";
            };
            focusedInactive = {
              border = "#${theme.color_second}";
              background = "#${theme.color_second}";
              text = "#ffffff";
              indicator = "#${theme.color_second}";
              childBorder = "#${theme.color_second}";
            };
            unfocused = {
              border = "#${theme.background}";
              background = "#${theme.background}";
              text = "#888888";
              indicator = "#${theme.background}";
              childBorder = "#${theme.background}";
            };
          };

          focus = {
            followMouse = true;
          };

          # no native bar (waybar usage out of scope for this port)
          bars = [ ];
        };

      extraConfig = ''
        corner_radius ${toString common.visuals.rounding}

        ${lib.optionalString common.visuals.blur.enable ''
          blur enable
          blur_radius ${toString common.visuals.blur.radius}
          blur_passes ${toString common.visuals.blur.passes}
        ''}

        default_orientation auto
      '';
    };
  };
}
