{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
let
  launch_vicinae = cmd: "${lib.getExe config.programs.vicinae.package} vicinae://${cmd}";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.desktop.launchers.vicinae = {
    enable = mkEnableOption "vicinae" // {
      default = config.my.desktop.launchers.enable;
    };
    enableHyprlandIntegration = mkEnableOption "vicinae hyprland integration" // {
      default = config.my.desktop.hyprland.enable;
    };
  };
  config = mkIf config.my.desktop.launchers.vicinae.enable {
    wayland.windowManager.hyprland.settings =
      mkIf config.my.desktop.launchers.vicinae.enableHyprlandIntegration
        {
          layerrule = [
            {
              name = "vicinae-blur";
              blur = "on";
              ignore_alpha = 0;
              "match:namespace" = "vicinae";
            }
            {
              name = "vicinae-no-animation";
              no_anim = "on";
              "match:namespace" = "vicinae";
            }
          ];
          bind = [
            "$mod, D, exec, ${launch_vicinae "toggle"}"

          ];

        };
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
      # useLayerShell = false;
      settings = {
        close_on_focus_loss = true;
        providers = {
          "@Gelei/bluetooth-0" = {
            preferences = {
              connectionToggleable = true;
            };
          };
          "core" = {
            "entrypoints" = {
              "about" = {
                "enabled" = false;
              };
              "documentation" = {
                "enabled" = false;
              };
              "keybind-settings" = {
                "enabled" = false;
              };
              "list-extensions" = {
                "enabled" = false;
              };
              "manage-fallback" = {
                "enabled" = false;
              };
              "oauth-token-store" = {
                "enabled" = false;
              };
              "open-config-file" = {
                "enabled" = false;
              };
              "open-default-config" = {
                "enabled" = false;
              };
              "report-bug" = {
                "enabled" = false;
              };
              "sponsor" = {
                "enabled" = false;
              };
              "store" = {
                "enabled" = false;
              };
            };
          };
          "developer" = {
            "enabled" = false;
          };
          "font" = {
            "enabled" = false;
          };
        };
      };
      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        bluetooth
        nix
        firefox
        power-profile
        player-pilot
        process-manager
        pulseaudio
        wifi-commander
      ];
    };
  };
}
