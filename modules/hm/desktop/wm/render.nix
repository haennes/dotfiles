# Render the shared `bindings`/`submaps` spec to each WM's native config.
#
#   hyprland.bindings bindings  -> list of "bind(=...) = MODS, key, action" lines
#   hyprland.submaps  submaps   -> extraConfig text (entry bind + blocks + resets)
#   sway.keybindings  bindings submaps -> attrset "Mod+Key" = "sway cmd" (incl. submap entries)
#   sway.modes        submaps   -> attrset name = { "Key" = "sway cmd"; } for config.modes
{
  lib,
  keys,
}:
let
  inherit (lib) concatLists concatStringsSep mapAttrsToList optional;
  actionVariant = action: action.variant or "bind";

  swayKeyValuePairs = binds: concatLists (
    mapAttrsToList (combo: action:
      let
        comboStr = keys.combo.sway combo;
        actionStr = action.sway;
      in
      optional (comboStr != null && actionStr != null) {
        name = comboStr;
        value = actionStr;
      }
    ) binds
  );
in
{
  hyprland = {
    bindings = bindings: lib.filter (x: x != null) (
      mapAttrsToList (combo: action:
        let
          comboStr = keys.combo.hyprland combo;
          actionStr = action.hyprland;
        in
        if comboStr == null || actionStr == null then
          null
        else
          "${actionVariant action} = ${comboStr}, ${actionStr}"
      ) bindings
    );

    submaps = submaps: concatStringsSep "\n" (
      mapAttrsToList (name: sm:
        concatStringsSep "\n" (
          lib.filter (x: x != null) (
            (optional (keys.combo.hyprland sm.entry != null)
              "bind = ${keys.combo.hyprland sm.entry}, submap, ${name}")
            ++ [ "submap = ${name}" ]
            ++ mapAttrsToList (combo: action:
              let
                comboStr = keys.combo.hyprland combo;
                actionStr = action.hyprland;
              in
              if comboStr == null || actionStr == null then
                null
              else
                "${actionVariant action} = ${comboStr}, ${actionStr}"
            ) sm.binds
            ++ [ "submap = reset" ]
          )
        )
      ) submaps
    );
  };

  sway = {
    # bindings + submap entry binds (`mode <name>`), rendered into config.keybindings
    keybindings = bindings: submaps:
      lib.listToAttrs (
        (swayKeyValuePairs bindings)
        ++ concatLists (mapAttrsToList (name: sm:
          let comboStr = keys.combo.sway sm.entry; in
          optional (comboStr != null && builtins.length (swayKeyValuePairs sm.binds) > 0) {
            name = comboStr;
            value = "mode ${name}";
          }
        ) submaps)
      );

    modes = submaps: lib.mapAttrs (_name: sm:
      lib.listToAttrs (swayKeyValuePairs sm.binds)
    ) (lib.filterAttrs (_name: sm:
      builtins.length (swayKeyValuePairs sm.binds) > 0
    ) submaps);
  };
}