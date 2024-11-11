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
  };
}
