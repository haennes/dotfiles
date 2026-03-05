{
  inputs,
  pkgs,
  ...
}:
{
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
}
