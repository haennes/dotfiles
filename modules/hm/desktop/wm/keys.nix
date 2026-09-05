# Canonical key/modifier tokens and their per-WM rendering.
#
# A combo is a "+"-separated string, e.g. "mod+Shift+a". Every token except the
# last one is a modifier, the last one is the key. Tokens not in the tables
# below (letters, digits, `XF86*`, ...) pass through verbatim.
#
# `combo.hyprland` renders "super SHIFT, key"-style combos, `combo.sway` renders
# "Mod4+Shift+key"-style. A `null` result means the combo is unsupported on that
# WM (dropped by the renderers).
{
  lib,
}:
let
  inherit (lib) concatStringsSep;

  # canonical modifier token -> per-WM token
  mods = {
    hyprland = {
      mod = "SUPER";
      ctrl = "CTRL";
      shift = "SHIFT";
      alt = "ALT";
    };
    sway = {
      mod = "Mod4";
      ctrl = "Ctrl";
      shift = "Shift";
      alt = "Mod1";
    };
  };

  # canonical key token -> per-WM key label (null = unsupported on that WM)
  keys = {
    hyprland = {
      return = "return";
      space = "space";
      escape = "escape";
      arrow_l = "left";
      arrow_r = "right";
      arrow_u = "up";
      arrow_d = "down";
      mouse_left = "mouse:272";
      mouse_right = "mouse:273";
      mouse_wheel_up = "mouse_up";
      mouse_wheel_down = "mouse_down";
    };
    sway = {
      return = "Return";
      space = "space";
      escape = "Escape";
      arrow_l = "Left";
      arrow_r = "Right";
      arrow_u = "Up";
      arrow_d = "Down";
      mouse_left = null;
      mouse_right = null;
      mouse_wheel_up = "button4";
      mouse_wheel_down = "button5";
    };
  };

  modToken = wm: token:
    mods.${wm}.${lib.toLower token} or (throw "unknown modifier token '${token}'");

  keyToken = wm: token:
    if builtins.match "keycode:[0-9]+" token != null then
      (if wm == "hyprland" then "code:${builtins.substring 8 999999 token}" else null)
    else
      # Table keys are lowercase ("return", "arrow_l", ...); look up case-
      # insensitively. Hyprland matches named keys by keycode (case-insensitive),
      # but sway's keysyms are case-sensitive ("H" == Shift+h) - lowercase bare
      # letters so "mod+Q" means the q key without Shift on both WMs. Tokens not
      # in the table ("XF86*", "period", ...) pass through verbatim.
      keys.${wm}.${lib.toLower token}
      or (if builtins.match "[a-zA-Z]" token != null then lib.toLower token else token);

  # render one combo string for a given WM
  render =
    wm: combo:
    let
      parts = builtins.filter (p: lib.isString p && p != "") (builtins.split "\\+" combo);
      modifierTokens = lib.init parts;
      key = keyToken wm (lib.last parts);
    in
    if key == null then
      null
    else if modifierTokens == [ ] then
      (if wm == "hyprland" then ", ${key}" else key)
    else
      let
        modsRendered = concatStringsSep (if wm == "hyprland" then " " else "+") (map (modToken wm) modifierTokens);
      in
      if wm == "hyprland" then "${modsRendered}, ${key}" else "${modsRendered}+${key}";
in
{
  inherit mods keys;

  combo = {
    hyprland = render "hyprland";
    sway = render "sway";
  };
}