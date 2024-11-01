{ inputs, pkgs, lib, config, sshkeys, all_modules, ... }:
let
  hports = config.ports.ports.curr_ports;
  sports = hports.gitea;
  ips = config.ips.ips.ips.default;
  pg = config.services.postgresql.dataDir;
  dataDir = "/git";
in {

  imports = [ ../../modules/microvm_guest.nix ];

  microvm.shares = [{
    source = "/git";
    mountPoint = dataDir;
    tag = "git-${config.networking.hostName}";
    proto = "virtiofs";
  }];

  services.wireguard-wrapper.enable = true;
  networking.hostName = "vertumnus";

  networking.firewall.allowedTCPPorts = [ sports.web ];

  system.activationScripts.ensure-dirs-exist.text = ''
    mkdir -p ${dataDir}
    chown  ${config.services.gitea.user}:${config.services.gitea.group} -R ${dataDir}
    mkdir -p ${pg}
    chown postgres:postgres -R ${pg}
  '';
  services.gitea = rec {
    enable = true;
    lfs.enable = true;
    stateDir = dataDir;
    settings = {
      server = rec {
        DOMAIN = "git.hannses.de";
        HTTP_PORT = sports.web;
        SSH_DOMAIN = "hannses.de";
      };
      "repository.pull-request".DEFAULT_MERGE_STYLE = "rebase";
    };
    database = { type = "postgres"; };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ config.services.gitea.database.name ];
    ensureUsers = [{
      name = config.services.gitea.database.user;
      ensureDBOwnership = true;
      ensureClauses = {
        createdb = true;
        createrole = true;
        login = true;
      };
    }];
    dataDir = "/persist/pg";
    #initialScript = pkgs.writeText "postgresql-password" ''
    #  CREATE ROLE freshrss WITH LOGIN PASSWORD 'db-secret' CREATEDB;
    #'';
  };
}
