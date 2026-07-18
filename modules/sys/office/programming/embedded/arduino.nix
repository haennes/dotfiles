{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.programming.embedded.platformio.enable =
    mkEnableOption "Open source ecosystem for IoT development"
    // {
      default = config.my.office.programming.embedded.enable;
    };
  config = mkIf config.my.office.programming.embedded.platformio.enable {
    environment.systemPackages = with pkgs; [
      arduino
      arduino-ota
      segger-jlink
    ];
    nixpkgs.config.permittedInsecurePackages = [
      "segger-jlink-qt4-874"
    ];
    nixpkgs.config.segger-jlink.acceptLicense = true;

    users.users.hannses.extraGroups = [
      "dialout"
      "tty"
    ];

    services.udev.extraRules = ''
      KERNEL=="ttyUSB[0-9]*",MODE="0666"
      KERNEL=="ttyACM[0-9]*",MODE="0666"
    '';
  };
}
