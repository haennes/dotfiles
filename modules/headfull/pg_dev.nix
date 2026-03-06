{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    ensureUsers = [
      {
        name = "strichliste-rs";
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
      { name = "hannses"; }
    ];
    ensureDatabases = [
      "strichliste-rs"
      "uni"
      "playground"
    ];

    initialScript = pkgs.writeText "postgresql-password" ''
      GRANT ALL PRIVILEGES ON database uni TO hannses 
      GRANT ALL PRIVILEGES ON database playground TO hannses
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
