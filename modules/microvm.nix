{ config, ... }: {
  systemd.network.enable = true;
  systemd.network.wait-online.enable = !config.networking.networkmanager.enable;

  systemd.network.networks."10-lan" = {
    matchConfig.Name = [ "wlp1s0" "vm-*" ];
    networkConfig = { Bridge = "br0"; };
  };

  systemd.network.netdevs."br0" = {
    netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
  };

  systemd.network.networks."10-lan-bridge" = {
    matchConfig.Name = "br0";
    networkConfig = {
      Address =
        [ "${config.ips.ips.ips.default."vm-host".br0}/24" "2001:db8::a/64" ];
      IPv6AcceptRA = true;
    };
    linkConfig.RequiredForOnline = "routable";
  };
}
