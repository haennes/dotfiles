{ inputs, pkgs, lib, config, sshkeys, all_modules, ... }:
let
  hports = config.ports.ports.curr_ports;
  ips = config.ips.ips.ips.default;
  user_group = config.services.freshrss.user;
in {

  imports = [ ../../modules/microvm_guest.nix ];

  age.secrets."freshrss/password_hannses.age" = {
    file = ../../secrets/freshrss/password_hannses.age;
    owner = config.services.freshrss.user;
  };

  services.wireguard-wrapper.enable = true;
  services.syncthing_wrapper = {
    enable = true;
    ensureDirsExistsDefault = "setfacl";
  };
  services.syncthing = {
    dataDir = "/persist";
    user = config.services.freshrss.user;
  };

  networking.hostName = "fons";

  networking.firewall.allowedTCPPorts = [ 443 80 ];

  system.activationScripts.ensure-dirs-exist.text = let
    rss = config.services.freshrss.dataDir;
    pg = config.services.postgresql.dataDir;
  in ''
    mkdir -p ${rss}
    chown ${user_group}:${user_group} ${rss}
    mkdir -p ${pg}
    chown postgres:postgres ${pg}
  '';
  # official test: https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/freshrss-pgsql.nix
  services.freshrss = {
    enable = true;
    baseUrl = "http://${ips.fons.br0}";
    # api access: https://freshrss.github.io/FreshRSS/en/users/06_Mobile_access.html#enable-the-api-in-freshrss
    passwordFile = config.age.secrets."freshrss/password_hannses.age".path;
    defaultUser = "hannses";
    dataDir = "/persist/freshrss";
    database = {
      type = "pgsql";
      port = hports.postgresql;
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
    dataDir = "/persist/pg";
    initialScript = pkgs.writeText "postgresql-password" ''
      CREATE ROLE freshrss WITH LOGIN PASSWORD 'db-secret' CREATEDB;
    '';
  };

  systemd.services."freshrss-config" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
}
