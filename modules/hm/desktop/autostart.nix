{
  config,
  options,
  pkgs,
  lib,
  inputs,
  globals,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    ;
  inherit (lib.types)
    listOf
    str
    submodule
    ;

  # Flatten one arbitrarily nested layout tree into its leaf commands, keeping
  # the workspace they belong to. Workspace names keep their hyprland form
  # (e.g. "special:browser").
  flattenApps = workspace: node:
    if builtins.isString node then
      [
        {
          inherit workspace;
          cmd = node;
        }
      ]
    else
      lib.concatMap (flattenApps workspace) (
        lib.concatLists (builtins.attrValues node)
      );

  apps = lib.concatMap (
    workspace: flattenApps workspace config.my.desktop.autostart.autostart.${workspace}
  ) (builtins.attrNames config.my.desktop.autostart.autostart);

  # sway has no "special:" workspaces, that prefix is a hyprland convention.
  # Discard it; the layout tree passes through unchanged and already matches
  # what sway-layout consumes.
  swayLayout = {
    workspaces = lib.mapAttrs' (workspace: layouts:
      lib.nameValuePair
        (lib.removePrefix "special:" workspace)
        layouts
    ) config.my.desktop.autostart.autostart;
  };
in
{
  imports = [
    inputs.sway-layout.homeManagerModules.default
  ];

  options.my.desktop.autostart = {
    enable = mkEnableOption "autostart" // {
      default = config.my.desktop.enable;
    };
    autostart = mkOption {
      type = (options.programs.sway-layout.layout.type.getSubOptions null).workspaces.type;
      description = ''
        Programs to launch at startup, grouped by workspace.

        Each key is a workspace (e.g. "1" or "special:browser"), each value
        either a command string or a container choosing a layout ("tabbed",
        "splitv", "splith", "stacking") and listing its child nodes. Containers
        nest arbitrarily, matching sway-layout's config format. Layouts are
        honored by WMs that support per-workspace layouts (sway); hyprland uses
        the workspace placement only.
      '';
      default = { };
      example = {
        "1" = {
          tabbed = [
            "btop"
            {
              splitv = [
                "htop"
                "ncdu"
              ];
            }
          ];
        };
      };
    };

    apps = mkOption {
      type = listOf (submodule {
        options = {
          workspace = mkOption {
            type = str;
          };
          cmd = mkOption {
            type = str;
          };
        };
      });
      description = ''
        Every autostart command flattened from the nested layout trees to a
        single entry with its target workspace. Workspace names are passed
        through unchanged (e.g. "special:browser"). Consumed by hyprland's
        exec-once, which uses the workspace placement only.
      '';
      readOnly = true;
    };

    swayLayout = mkOption {
      # reuse the sway-layout module's own layout option type
      type = options.programs.sway-layout.layout.type;
      description = ''
        Layout definition for sway-layout, derived from autostart with the
        hyprland "special:" workspace prefix discarded.
      '';
      readOnly = true;
    };
  };

  options.my.desktop.sway.layout.enable = mkEnableOption "sway-layout autostart" // {
    default = config.my.desktop.sway.enable;
  };

  config = mkMerge [
    (mkIf config.my.desktop.autostart.enable {
      my.desktop.autostart.autostart = {
        "special:tasks" = "${globals.execute_term} --class tasks";
      };

      my.desktop.autostart.apps = apps;
    })

    (mkIf config.my.desktop.sway.layout.enable {
      programs.sway-layout.enable = true;
      programs.sway-layout.layout = config.my.desktop.autostart.swayLayout;
      my.desktop.autostart.swayLayout = swayLayout;
    })
  ];
}
