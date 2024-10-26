{ config, lib, ... }:
let
  inherit (lib) mkOption mapAttrsToList head;
  inherit (lib.types) str;
in {
  options.microvmHost.extInterface = mkOption { type = str; };
  config = {
    networking = {
      nat = {
        enable = true;
        enableIPv6 = true;
        # Change this to the interface with upstream Internet access
        externalInterface = config.microvmHost.extInterface;
        internalInterfaces = [ "br0" ];
      };
      bridges.br0.interfaces =
        mapAttrsToList (_n: v: (head v.config.config.microvm.interfaces).id)
        config.microvm.vms;
      interfaces."br0".ipv4.addresses = [{
        address = config.ips.ips.ips.default."vm-host".br0;
        prefixLength = 24;
      }];
    };
  };
}
