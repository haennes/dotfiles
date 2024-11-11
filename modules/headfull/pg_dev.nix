{ pkgs, ... }: {
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    ensureUsers = [{
      name = "strichliste-rs";
      ensureDBOwnership = true;
      ensureClauses.login = true;
    }];
    ensureDatabases = [ "strichliste-rs" ];

    initialScript = pkgs.writeText "postgresql-password" ''
      CREATE ROLE strichliste-rs WITH LOGIN PASSWORD 'secret' CREATEDB;
    '';
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      # ipv4
      local all       all     trust
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';
  };
  #users.users.strichliste-rs.isNormalUser = true;
}
