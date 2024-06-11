{ pkgs, lib, inputs, theme, globals, scripts, ... }:
with inputs; {
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;
    xwayland.enable = true;

    plugins = [
      #split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      #hyprgrass.packages.${pkgs.system}.default
    ];

    settings = {
      "$terminal" = "${globals.term}";
      "$runprompt" = "${scripts.selector}";
      "$volume" = "${scripts.volume}";
      "$brightness" = "${scripts.brightness}";
      # TODO implement screenshot dmenu script

      exec-once =  scripts.startup;

      monitor = [
        ",preferred,auto,1"
      ];

      input = {
        kb_layout = "de,us,eu";
        kb_options = "caps:escape_shifted_capslock";

        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          drag_lock = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" =
          "rgba(${theme.color_first}ee) rgba(${theme.color_second}ee) 45deg";
        "col.inactive_border" = "rgba(${theme.background}aa)";

        layout = "dwindle";

        allow_tearing = false;
      };

      layerrule = [ "blur" "ignorezero" ];

      decoration = {
        rounding = 10;

        active_opacity = 0.9;
        inactive_opacity = 0.75;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
        };

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.09, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = { new_is_master = true; };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
        #workspace_swipe_numbered = true;
        workspace_swipe_cancel_ratio = 0.15;
      };

      misc = {
        force_default_wallpaper =
          -1; # 0 or 1 to disable anime mascot wallpapers
      };

      "$mod" = "SUPER";

      bind = [
        # apps
        "$mod, return, exec, $terminal"
        "CTRL, space, exec, $runprompt"
        "$mod SHIFT, L, exec, ${scripts.lock}"
        "$mod, V, exec, ${scripts.clipboard}"
        "$mod SHIFT, S, exec, grim"

        # kill window
        "$mod, Q, killactive"

        # kill hyprland
        "$mod SHIFT CTRL, Q, exit"

        # focus movement
        "$mod, left, movefocus, l"
        "$mod, H, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, L, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, K, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, J, movefocus, d"

        # workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        #"$mod, 1, split-workspace, 1"
        #"$mod, 2, split-workspace, 2"
        #"$mod, 3, split-workspace, 3"
        #"$mod, 4, split-workspace, 4"
        #"$mod, 5, split-workspace, 5"
        #"$mod, 6, split-workspace, 6"
        #"$mod, 7, split-workspace, 7"
        #"$mod, 8, split-workspace, 8"
        #"$mod, 9, split-workspace, 9"

        "$mod, space, togglespecialworkspace, special:scratch"
        "$mod, period, exec, ${scripts.switchmonitor} -n"
        "$mod, comma, exec, ${scripts.switchmonitor} -p"

        # touch workspaces
        " , edge:l:r, workspace, e-1"
        " , edge:r:l, workspace, e+1"

        #" , edge:l:r, split-workspace, e-1"
        #" , edge:r:l, split-workspace, e+1"

        # window
        "$mod, M, fullscreen, 1"
        "$mod CTRL, M, fullscreen, 0"
        "$mod, F, togglefloating"
        "$mod SHIFT, 0, pin"

        # move to workspace
        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
        "$mod SHIFT, space, movetoworkspacesilent, special:scratch"
        #"$mod SHIFT, 1, split-movetoworkspacesilent, 1"
        #"$mod SHIFT, 2, split-movetoworkspacesilent, 2"
        #"$mod SHIFT, 3, split-movetoworkspacesilent, 3"
        #"$mod SHIFT, 4, split-movetoworkspacesilent, 4"
        #"$mod SHIFT, 5, split-movetoworkspacesilent, 5"
        #"$mod SHIFT, 6, split-movetoworkspacesilent, 6"
        #"$mod SHIFT, 7, split-movetoworkspacesilent, 7"
        #"$mod SHIFT, 8, split-movetoworkspacesilent, 8"
        #"$mod SHIFT, 9, split-movetoworkspacesilent, 9"
        #"$mod SHIFT, space, split-movetoworkspacesilent, special:scratch"

        #"$mod SHIFT, period, changemonitorsilent, next"
        #"$mod SHIFT, comma, changemonitorsilent, prev"

        #"$mod SHIFT, period, split-changemonitorsilent, next"
        #"$mod SHIFT, comma, split-changemonitorsilent, prev"

        # Scroll through exisiting workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

      ];

      # resize window
      binde = [
        #"$mod, R, submap, resize" # TODO search for submaps in nixconf
        #"$mod SHIFT, equal, resizeactive, 10 0"
        #"$mod minus, resizeactive, -10 0"
        #"$mod CTRL, SHIFT, equal, resizeactive, 0 10"
        #"$mod CTRL, minus, resizeactive, 0 -10"
        "$mod, P, togglesplit"
        "$mod SHIFT, S, exec, grimblast copy area"
      ];

      # mouse
      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

      # activate even when locked, hold = repeat
      bindle = [
        # volume keys
        ", XF86AudioRaiseVolume, exec, $volume -i"
        ", XF86AudioLowerVolume, exec, $volume -d"
        ", XF86AudioMute, exec, $volume -t"
        ", XF86AudioMicMute, exec, $volume -m"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

        # brightness keys
        ", XF86MonBrightnessUp, exec, $brightness -i"
        ", XF86MonBrightnessDown, exec, $brightness -d"
      ];
    };

    extraConfig = ''
      plugin {
        split-monitor-workspaces {
          count = 9
          }
        }

          # window resize
          bind = $mod, R, submap, resize

          submap = resize

          binde = , left, resizeactive, -10 0
          binde = , H, resizeactive, -10 0
          binde = , right, resizeactive, 10 0
          binde = , L, resizeactive, 10 0
          binde = , up, resizeactive, 0 -10
          binde = , K, resizeactive, 0 -10
          binde = , down, resizeactive, 0 10
          binde = , J, resizeactive, 0 10

          bind = , escape, submap, reset
          bind = , return, submap, reset
          submap = reset

          # window move
          bind = $mod SHIFT, M, submap, move

          submap = move

          binde = , left, movewindow, l
          binde = , H, movewindow, l
          binde = , right, movewindow, r
          binde = , L, movewindow, r
          binde = , up, movewindow, u
          binde = , K, movewindow, u
          binde = , down, movewindow, d
          binde = , J, movewindow, d

          bind = , escape, submap, reset
          bind = , return, submap, reset
          submap = reset

          # layout switching

          # window swapping
          bind = $mod, S, submap, swap


          submap = swap

          binde = , left, swapwindow, l
          binde = , left,  submap, reset
          binde = , H, swapwindow, l
          binde = , H,  submap, reset
          binde = , right, swapwindow, r
          binde = , right,  submap, reset
          binde = , L, swapwindow, r
          binde = , L,  submap, reset
          binde = , up, swapwindow, u
          binde = , up,  submap, reset
          binde = , K, swapwindow, u
          binde = , K,  submap, reset
          binde = , down, swapwindow, d
          binde = , down,  submap, reset
          binde = , J, swapwindow, d
          binde = , J,  submap, reset

          bind = , escape, submap, reset
          bind = , return, submap, reset
          submap = reset

          # togglesd
          bind = $mod SHIFT, T, submap, toggle

          submap = toggle
          binde = , O, toggleopaque
          binde = , O, submap, reset

          bind = , escape, submap, reset
          bind = , return, submap, reset
          submap = reset
    '';
  };
}
