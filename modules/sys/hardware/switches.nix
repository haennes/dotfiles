{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.hardware.switches.enable = mkEnableOption "switches behaviour" // {
    default = config.my.hardware.enable;
  };
  config = mkIf config.my.hardware.switches.enable {
    services.logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandleLidSwitch = "suspend";
    };
  };
}
