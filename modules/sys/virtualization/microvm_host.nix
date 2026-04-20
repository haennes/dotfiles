{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption mkIf;
  inherit (lib.types) str;
in
{
  options.microvmHost = {
    extInterface = mkOption { type = str; };
    systemd = mkEnableOption "systemd networkd";
  };
  config = mkIf config.is_microvm_host {
    networking = {
      nat = {
        enable = true;
        enableIPv6 = true;
        # Change this to the interface with upstream Internet access
        externalInterface = config.microvmHost.extInterface;
        internalInterfaces = [ "br0" ];
      };
    };
  };
}
