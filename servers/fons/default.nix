{ pkgs, hports, lib, ips, config, macs, sshkeys, ... }:
let data = name: "/data/${name}";
in {
  microvm = {
    #...add additional MicroVM configuration here
    interfaces = [{
      type = "tap";
      id = "vm-fons";
      mac = "${macs.vm-fons.eth0}";
    }];
  };
  systemd.network.enable = true;

  systemd.network.networks."20-lan" = {
    matchConfig.Type = "ether";
    networkConfig = {
      Address = [ "${ips.vm-fons.br0}/24" "2001:db8::b/64" ];
      Gateway = ips."vm-host".br0;
      DNS = [ ips."vm-host".br0 ];
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

  networking.firewall.allowedTCPPorts = [ 443 80 ];
  services.freshrss = rec {
    enable = true;
    baseUrl = "https://0.0.0.0";
    authType = "none";
    database = { # use postgres just because we already have it
      #port = hports.postgresql;
      host = "/var/lib/postgresql";
      type = "pgsql";
    };
    # to configure a nginx virtual host directly:
  };
  services.postgresql = {
    enable = true;
    settings.port = hports.postgresql;
    ensureUsers = [{
      name = config.services.freshrss.database.user;
      ensureClauses.login = true;
    }];
    ensureDatabases = [ config.services.freshrss.database.name ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };
}
