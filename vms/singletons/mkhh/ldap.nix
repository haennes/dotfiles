{config, lib, pkgs, ...}:
let
  lldap-user = "lldap";
  lldap-group = "lldap";
  lldap-db = lldap-user; #ensureUser works this way
in
{
   age.secrets = {
 lldap-jwt-secret = {
      file = ../../../secrets/lldap/mkhh/jwt.age;
      owner = lldap-user;
      group = lldap-group;
    };

    lldap-key-seed = {
      file = ../../../secrets/lldap/mkhh/key-seed.age;
      owner = lldap-user;
      group = lldap-group;
    };

    lldap-user-pass = {
      file = ../../../secrets/lldap/mkhh/user-pass.age;
      owner = lldap-user;
      group = lldap-group;
    };
  };
  services.postgresql = {
    enable = true;
    ensureUsers = lib.my.postgres-ensureUser lldap-user;
    ensureDatabases = [lldap-user];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      # ipv4
      local all       all     trust
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';
    };

  services.lldap = {
    enable = true;
    settings = {
      ldap_base_dn = "dc=mkhh,dc=hannses,dc=de";
      ldap_user_email = "admin@mkhh.hannses.de";
      database_url = "postgresql://lldap@localhost/lldap?host=/run/postgresql";
    };
    environment = {
      LLDAP_JWT_SECRET_FILE = config.age.secrets.lldap-jwt-secret.path;
      LLDAP_KEY_SEED_FILE = config.age.secrets.lldap-key-seed.path;
      LLDAP_LDAP_USER_PASS_FILE = config.age.secrets.lldap-user-pass.path;
    };
  };

  services.nginx.virtualHosts."users.mkhh.hannses.de" =
    lib.custom.settings."nix-server".nginx-local-ssl // {
      locations."/".proxyPass =
        "http://localhost:${toString config.services.lldap.settings.http_port}";
    };

  systemd.services.lldap = let deps = [ "postgresql.service" ];
  in {
    after = deps;
    requires = deps;

    serviceConfig.DynamicUser = lib.mkForce false;
  };

  users = {
    users.lldap = {
      group = "lldap";
      isNormalUser = true;
    };

    groups.lldap = { };
  };
}
}
