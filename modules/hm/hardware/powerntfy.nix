{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  package = pkgs.callPackage (
    {
      lib,
      pkg-config,
      cmake,
      libnotify,
      rustPlatform,
      fetchFromGitHub,
    }:

    rustPlatform.buildRustPackage (finalAttrs: {
      pname = "bato";
      version = "0.2.1";

      src = fetchFromGitHub {
        owner = "doums";
        repo = "bato";
        rev = "master";
        hash = "sha256-1HCU8g1mhCFtWCsybJ1wxK+JihssJiMDq0vZ36oylWQ=";
      };

      cargoHash = "sha256-nk5NtUElByy652xX47vK8Fdzzsk29J1aEx7Y3ABk3Rc=";

      nativeBuildInputs = [
        pkg-config
        cmake
        pkgs.udev
      ];

      buildInputs = [
        libnotify
        pkgs.udev
      ];

      meta = {
        description = "Small program to send battery notifications";
        homepage = "https://github.com/doums/bato";
        changelog = "https://github.com/doums/bato/releases/tag/v${finalAttrs.version}";
        license = lib.licenses.mpl20;
        maintainers = with lib.maintainers; [ HaskellHegemonie ];
        platforms = lib.platforms.linux;
        mainProgram = "bato";
      };
    })
  ) { };
in
{
  options.my.hardware.powerntfy.enable = mkEnableOption "power notifications" // {
    default = osConfig.has_battery && osConfig.is_client && config.my.hardware.enable;
  };

  config.services.bato = mkIf config.my.hardware.powerntfy.enable {
    enable = true;
    inherit package; # remove on upstream update
    settings = {
      # The tick rate, in second, at which battery info is polled
      # default: 2
      tick_rate = 2;

      # The battery to monitor, located in `/sys/class/power_supply/<BAT_NAME>/`
      # If not provided, bato will try to find one
      # bat_name = "BAT0"

      # The critical level of the battery, as a percentage
      # default 5
      critical_level = 5;

      # The low level of the battery, as a percentage
      # default 20
      low_level = 20;

      # Whether the current level is calculated based on the full design value
      # default true
      full_design = false;

      # # # # #
      # Notifications settings
      # If you omit one, the corresponding notification is disabled
      # They take the following properties:
      # `summary` main notification text, oneline (required)
      # `body` optional multiline text
      # `icon` optional icon name (from a freedesktop.org-compliant icon theme)
      # `urgencey` optional urgency level, low | normal | critical

      charging = {
        summary = "Battery";
        body = "Charging";
        icon = "battery-good-charging";
      };

      discharging = {
        summary = "Battery";
        body = "Discharging";
        icon = "battery-good";
      };

      full = {
        summary = "Battery";
        body = "Full";
        icon = "battery-full";
      };

      low = {
        summary = "Battery";
        body = "Low";
        icon = "battery-low";
      };

      critical = {
        summary = "Battery";
        body = "Critical!";
        icon = "battery-caution";
        urgency = "critical";
      };

    };
  };
}
