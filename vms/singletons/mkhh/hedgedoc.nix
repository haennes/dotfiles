{ config, lib, pkgs, ... }:
let
  domain = "pad.mkhh.hannses.de";
  hports = config.ports.ports.curr_ports;
  uploadsPath = "/persist/hedgedoc";
  owner = "hedgedoc";
  group = "hedgedoc";
in {

  system.activationScripts.ensure-hedgedoc-dirs-exist = {
    deps = [ "users" "groups" ];
    text = ''
      mkdir -p ${uploadsPath}
      chown -R ${owner}:${group} ${uploadsPath}
    '';
  };

  networking.firewall.allowedTCPPorts =
    [ config.ports.ports.curr_ports.hedgedoc 80 443 ];

  services.postgresql = {
    enable = true;
    ensureUsers = lib.my.postgres-ensureUser owner;
    ensureDatabases = [ owner ];
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

  services.hedgedoc = {
    enable = true;
    settings = rec {
      inherit domain;
      port = hports.hedgedoc;
      host = config.ips.ips.ips.default.mkhh.wg0;
      #protocolUseSSL = true;
      #hsts.enable = true;
      allowOrigin = [ domain host ];
      #csp = {
      #  enable = true;
      #  upgradeInsecureRequest = "auto";
      #  addDefaults = true;
      #};

      db = {
        dialect = "sqlite";
        host = "/run/postgresql";
        username = owner;
        database = owner;
      };
      inherit uploadsPath;

      allowAnonymous = true;
      defaultPermission = "private"; # Privacy first
      allowFreeURL = true;
      allowGravatar = false;

      email = false;
      allowEmailRegister = true;
      #ldap = { //TODO
      #  url = "ldaps://dc2.hs-regensburg.de";
      #  providerName = "NDS Kennung";
      #  searchBase = "ou=HSR,dc=hs-regensburg,dc=de";
      #  searchAttributes = [ "displayName" "mail" "cn" ];
      #  searchFilter = "(cn={{username}})";
      #  userNameField = "displayName";
      #  useridField = "cn";
      #  tlsca="";
      #};
    };
  };

  #services.nginx.virtualHosts.${domain} = {
  #  #forceSSL = true;
  #  #enableACME = true;

  #  locations."/".proxyPass = "http://localhost:${
  #      builtins.toString config.services.hedgedoc.settings.port
  #    }";
  #};
}
