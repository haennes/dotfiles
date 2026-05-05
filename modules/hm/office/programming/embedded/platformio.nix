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
    home.packages = with pkgs; [ platformio ];
  };
}
