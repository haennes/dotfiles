{ config, lib, ... }:
let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) str;
in {
  options.microvmHost = {
    extInterface = mkOption { type = str; };
    systemd = mkEnableOption "systemd networkd";
  };
  config = {
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
  imports = [ ./microvm_host_stock.nix ./microvm_host_systemd.nix ];

}
