{ hports, lib, ips, config, macs, sshkeys, ... }:
let data = name: "/data/${name}";
in {
  microvm = {
    #...add additional MicroVM configuration here
    interfaces = [{
      type = "tap";
      id = "vm-test3";
      mac = "${macs.vm-fons.eth0}";
    }];
  };
  systemd.network.enable = true;

  systemd.network.networks."20-lan" = {
    matchConfig.Type = "ether";
    networkConfig = {
      Address = [ "192.168.1.3/24" "2001:db8::b/64" ];
      Gateway = "192.168.1.1";
      DNS = [ "192.168.1.1" ];
      IPv6AcceptRA = true;
      DHCP = "no";
    };
  };
  #services.syncthing_wrapper.enable = false;

  networking.useDHCP = lib.mkForce false;
  networking.hostName = "fons";
  users.users.root.password = "root";

  services.openssh = {
    enable = true; # TODO: extract into module
    ports = [ hports.sshd ];
  };
  users.users.root.openssh.authorizedKeys.keys = [ sshkeys.hannses ];

  services.freshrss = rec {
    enable = true;
    baseUrl = "localhost";
    authType = "none";
    database = { # use postgres just because we already have it
      port = hports.postgresql;
      type = "pgsql";
    };
    # to configure a nginx virtual host directly:
  };
  services.postgresql = {
    settings.port = hports.postgresql;
    enable = true;
  };
}
