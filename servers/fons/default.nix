{ hports, lib, ips, config, macs, ... }:
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

  #services.syncthing_wrapper.enable = false;

  networking.useDHCP = lib.mkForce true;
  networking.hostName = "fons";
  users.users.root.password = "root";

  #services.freshrss= rec {
  #  enable = true;
  #  baseUrl = "localhost";
  #  authType = "none";
  #  database = { #use postgres just because we already have it
  #    port = hports.postgresql;
  #    type = "pgsql";
  #  };
  #  # to configure a nginx virtual host directly:
  #};
  #services.postgresql = {
  #  enable = true;
  #};
}
