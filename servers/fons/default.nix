{ inputs, pkgs, lib, config, sshkeys, all_modules, ... }:
let
  hports = config.ports.ports.curr_ports;
  data = name: "/data/${name}";
  ips = config.ips.ips.ips.default;
in {
  microvm = {
    #...add additional MicroVM configuration here
    interfaces = [{
      type = "tap";
      id = "vm-fons";
      mac = "${config.macs.macs.vm-host.vm-fons.eth0}";
    }];
  };
  imports = all_modules;
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

  # official test: https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/freshrss-pgsql.nix
  services.freshrss = {
    enable = true;
    baseUrl = "http://localhost";
    #passwordFile = pkgs.writeText "password" "secret";
    defaultUser = "hannses";
    authType = "none";
    dataDir = "/srv/freshrss";
    database = {
      type = "pgsql";
      port = 5432;
      user = "freshrss";
      #NOTE: having the password here in plain text is ok since postgres is behind the firewall
      #TODO: fix it anyways at some point
      passFile = pkgs.writeText "db-password" "db-secret";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "freshrss" ];
    ensureUsers = [{
      name = "freshrss";
      ensureDBOwnership = true;
    }];
    initialScript = pkgs.writeText "postgresql-password" ''
      CREATE ROLE freshrss WITH LOGIN PASSWORD 'db-secret' CREATEDB;
    '';
  };

  systemd.services."freshrss-config" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
}
