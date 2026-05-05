{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.hardware.fwupd.enable = mkEnableOption "fwupd" // {
    default = config.my.hardware.enable;
  };
  config = mkIf config.my.hardware.fwupd.enable {
    services.fwupd.enable = true;
  };
}
