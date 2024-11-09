{ config, lib, ... }: {
  config = lib.mkIf config.microvmHost.systemd {
    systemd.network = {
      netdevs."10-microvm".netdevConfig = {
        Kind = "bridge";
        Name = "br0";
      };
      networks = {
        "10-microvm" = {
          matchConfig.Name = "br0";
          networkConfig = {
            DHCPServer = true;
            IPv6SendRA = false;
          };
          addresses = [{
            Address = "${config.ips.ips.ips.default."vm-host".br0}/24";
          }
          #{ Address = "fd12:3456:789a::1/64"; }
            ];
          #ipv6Prefixes = [{ ipv6PrefixConfig.Prefix = "fd12:3456:789a::/64"; }];
        };

        "11-microvm" = {
          matchConfig.Name = "vm-*";
          # Attach to the bridge that was configured above
          networkConfig.Bridge = "br0";
        };
      };

    };

    # Allow inbound traffic for the DHCP server
    networking.firewall.allowedUDPPorts = [ 67 ];
  };
}
