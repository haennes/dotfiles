{ config, lib, ... }: {
config = lib.mkIf (!config.microvmHost.systemd) {
  networking.bridges.br0.interfaces =
    lib.mapAttrsToList (_n: v: (lib.head v.config.config.microvm.interfaces).id)
    config.microvm.vms;
  networking.interfaces."br0".ipv4.addresses = [{
    address = config.ips.ips.ips.default."vm-host".br0;
    prefixLength = 24;
  }];
};
}
