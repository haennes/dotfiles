# Action constructors for the shared window manager keybinding format.
#
# Every constructor returns a mapping `{ hyprland = "..."; sway = "..."; }` and
# optionally a `variant` (`bind`/`binde`/`bindl`/`bindle`/`bindm`, hyprland
# only, ignored by sway). A `null` action string means that WM drops the
# binding.
{
  config,
  lib,
  pkgs,
}:
let
  inherit (builtins) toString;
  abs = n: if n < 0 then -n else n;
  dirName = {
    l = "left";
    r = "right";
    u = "up";
    d = "down";
  };
  mk = hyprland: sway: { inherit hyprland sway; };
  relHyprland = rel: if rel > 0 then "e+${toString rel}" else "e-${toString (abs rel)}";
  relSway = rel: if rel > 0 then "next" else "prev";
  relSwaylr = rel: if rel > 0 then "right" else "left";
  relMonitorHyprland = rel: if rel > 0 then "+${toString rel}" else "-${toString (abs rel)}";

  normalWorkspaces = config.my.desktop.wm.common.normalWorkspaces;
  specialNames = builtins.attrNames config.my.desktop.wm.common.specialWorkspaces;

  # sway-only: cycling through normal workspaces must skip the special
  # workspaces (web/tasks/chat). Hyprland's `workspace e+1` never enters a
  # `special:` workspace, so it already skips them; sway needs a script.
  swaymsgPath = lib.makeBinPath [ pkgs.swayfx ];
  normalList = lib.concatStringsSep " " (map (w: "\"${w}\"") normalWorkspaces);
  cycleScript = /* nu */ ''
    def workspace-cycle [dir: int] {
      let normal = [ ${normalList} ]

      let current = (
        swaymsg -t get_workspaces
        | from json
        | where focused == true
        | get 0.name
      )

      let idx = ($normal | enumerate | where item == $current | get 0?.index?)

      if $idx == null {
        if $dir > 0 { $normal | first } else { $normal | last }
      } else {
        let len = ($normal | length)
        let target = ($normal | get ((($idx + $dir + $len) mod $len)))
        $target
      }
    }
  '';
  workspaceNext = pkgs.writers.writeNu "workspace-next" {
    makeWrapperArgs = [ "--prefix" "PATH" ":" swaymsgPath ];
  } /* nu */ ''
    ${cycleScript}

    swaymsg workspace (workspace-cycle 1)
  '';
  workspacePrev = pkgs.writers.writeNu "workspace-prev" {
    makeWrapperArgs = [ "--prefix" "PATH" ":" swaymsgPath ];
  } /* nu */ ''
    ${cycleScript}

    swaymsg workspace (workspace-cycle -1)
  '';

  # sway-only: special workspaces (web/tasks/chat) behave like hyprland's
  # `togglespecialworkspace`: from a normal workspace you go to the special
  # one, from the special you return to the remembered last normal workspace,
  # and switching between specials preserves that remembered workspace. The
  # special always opens on the currently focused monitor: if it is already
  # shown on another output, it is moved to the focused one.
  specialsList = lib.concatStringsSep " " (map (n: "\"${n}\"") specialNames);
  specialToggleScript = pkgs.writers.writeNu "workspace-toggle" {
    makeWrapperArgs = [ "--prefix" "PATH" ":" swaymsgPath ];
  } /* nu */ ''
    def main [special: string] {
      let specials = [ ${specialsList} ]
      let state_file = $env.XDG_RUNTIME_DIR + "/sway-last-normal"

      let focused_output = (
        swaymsg -t get_outputs
        | from json
        | where focused == true
        | get 0?.name
      )

      let current = (
        swaymsg -t get_workspaces
        | from json
        | where focused == true
        | get 0.name
      )

      if $current == $special {

        if ($state_file | path exists) {
          swaymsg workspace (open $state_file | str trim)
        }

      } else {

        if not ($specials | any {|x| $x == $current }) {
          $current | save -f $state_file
        }

        let target = (
          swaymsg -t get_workspaces
          | from json
          | where name == $special
          | get 0?
        )

        # always show the special workspace on the currently focused monitor
        if ($target != null) and ($target.output? != null) and ($focused_output != null) and ($target.output != $focused_output) {
          swaymsg workspace $special
          swaymsg move workspace to output $focused_output
        }

        swaymsg workspace $special
      }
    }
  '';

  # sway-only: toggle the focused window between tiled and a floating 95%
  # square centered on the monitor (hyprland: `togglefloating`).
  # sway-only: switch to a workspace and bring it to the currently focused
  # output (hyprland: chained `workspace N; movecurrentworkspacetomonitor
  # active`).
  workspaceSwitchScript = pkgs.writers.writeNu "workspace-switch" {
    makeWrapperArgs = [ "--prefix" "PATH" ":" swaymsgPath ];
  } /* nu */ ''
    def main [ws: string] {
      let target = (
        swaymsg -t get_outputs
        | from json
        | where focused == true
        | get 0?.name
      )

      swaymsg workspace $ws

      if $target != null {
        let current = (
          swaymsg -t get_workspaces
          | from json
          | where name == $ws
          | get 0?.output
        )

        if $current != null and $current != $target {
          swaymsg move workspace to output $target
        }
      }
    }
  '';

  floatToggleScript = pkgs.writers.writeNu "float-toggle" {
    makeWrapperArgs = [ "--prefix" "PATH" ":" swaymsgPath ];
  } /* nu */ ''
    let tree = (swaymsg -t get_tree | from json)

    def find-focused [node] {
        if ($node.focused? | default false) {
            return $node
        }

        for child in (($node.nodes? | default []) ++ ($node.floating_nodes? | default [])) {
            let result = (find-focused $child)
            if $result != null {
                return $result
            }
        }

        null
    }

    let focused = (find-focused $tree)

    if ($focused.floating? | default false) {
        swaymsg floating disable
    } else {
        swaymsg floating enable
        swaymsg resize set width 95 ppt
        swaymsg resize set height 95 ppt
        swaymsg move position center
    }
  '';
in
rec {
  # misc keybindings
  exec = cmd: mk "exec ${cmd}" "exec ${cmd}";
  kill = mk "killactive" "kill";
  quit = mk "exit" "exit";
  lock = exec config.my.desktop.lock.lock_cmd;

  # focus/window
  focus = dir: mk "movefocus ${dir}" "focus ${dirName.${dir}}";
  fullscreen = mk "fullscreen 0" "fullscreen toggle";
  maximize = mk "fullscreen 1" "layout toggle tabbed split";
  toggleFloat = mk "togglefloating" "exec ${floatToggleScript}";
  toggleSplit = mk "layoutmsg togglesplit" "layout toggle split";
  pin = mk "pin" null;

  # workspaces
  workspace = n: mk "workspace ${toString n}" "workspace number ${toString n}";
  # relative cycling skips the special workspaces: hyprland never enters a
  # `special:` workspace with `workspace e+1`, sway runs a cycle script.
  workspaceRel = rel: mk "workspace ${relHyprland rel}" "exec ${if rel > 0 then workspaceNext else workspacePrev}";
  moveToWorkspace = n: mk "movetoworkspacesilent ${toString n}" "move container to workspace number ${toString n}";
  # switch to a workspace on the currently focused monitor
  workspaceToCurrentMonitor = n: mk
    "workspace ${toString n}; movecurrentworkspacetomonitor active"
    "exec ${workspaceSwitchScript} ${toString n}";
  workspaceToOutputRel = rel: mk "movecurrentworkspacetomonitor ${relMonitorHyprland rel}" "move workspace to output ${relSwaylr rel}";

  # focus the next/previous monitor (hyprland: `focusmonitor +1`; sway: `focus
  # output next`, which cycles through outputs in configuration order)
  switchMonitor = rel: mk "focusmonitor ${relMonitorHyprland rel}" "focus output ${relSwaylr rel}";

  # named special workspaces. hyprland: `togglespecialworkspace`; sway: the
  # workspace-toggle script (remembers/returns to the last normal workspace).
  specialToggle = name:
    mk
      "togglespecialworkspace ${name}"
      "exec ${specialToggleScript} ${name}";

  # submaps / modes
  enterSubmap = name: mk "submap ${name}" "mode ${name}";
  reset = mk "submap reset" "mode default";

  # submap actions
  resizeAxis =
    axis: amount:
    let
      x = if axis == "w" then amount else 0;
      y = if axis == "h" then amount else 0;
      swayAxis = if axis == "w" then "width" else "height";
      sign = if amount < 0 then "shrink" else "grow";
    in
    mk
      "resizeactive ${toString x} ${toString y}"
      "resize ${sign} ${swayAxis} ${toString (abs amount)} px";
  moveDir = dir: mk "movewindow ${dir}" "move ${dirName.${dir}}";
  # sway has no `swapwindow`; emulate a swap by moving the focused window and
  # re-focusing it in the destination slot.
  swapDir = dir: mk "swapwindow ${dir}" "move ${dirName.${dir}}; focus ${dirName.${dir}}";

  # variant combinators (hyprland only; sway ignores the variant field)
  repeat = a: a // { variant = "binde"; };
  locked = a: a // { variant = "bindl"; };
  lockedRepeat = a: a // { variant = "bindle"; };
}
