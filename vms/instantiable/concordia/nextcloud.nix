{ pkgs, config, lib, ... }:
let
  owner = config.services.syncthing.user;
  group = config.services.syncthing.group;
  NCdataDir = "/data/nextcloud";
  PGdataDir = "/data/pg";
  SCdataDir = "/data/syncthing";
  IPFSdataDir = config.services.kubo.dataDir;
in {

  age.secrets = {
    nextcloud_adminpass = {
      file = ../../../secrets/nextcloud/adminpass.age;
      inherit group owner;
    };
  };

  boot.kernel.sysctl = { "fs.inotify.max_user_watches" = 204800; };
  services.syncthing = rec {
    dataDir = SCdataDir;
    user = "nextcloud";
    group = user;
  };
  #services.syncthing_wrapper = { enable = true; };
  systemd.services."nextcloud-setup".requires = [ "syncthing.service" ];
  systemd.services."nextcloud-setup".after = [ "syncthing.service" ];

  #system.activationScripts.ensure-syncthing-dir-ownership.deps =
  #  [ "users" "groups" ];
  #system.activationScripts.ensure-syncthing-dir-permissions.deps =
  #  [ "users" "groups" ];
  system.activationScripts.ensure-dirs-exist = {
    deps = [ "users" "groups" ];
    text = ''
      mkdir -p ${NCdataDir}
      chown -R ${owner}:${group} ${NCdataDir}
      mkdir -p ${SCdataDir}
      chown -R ${owner}:${group} ${SCdataDir}
      mkdir -p ${IPFSdataDir}
      chown -R ${owner}:${group} ${IPFSdataDir}
    '';
  };
  #mkdir -p ${PGdataDir}
  #chown postgres:postgres ${PGdataDir}

  networking.firewall.allowedTCPPorts =
    [ config.ports.ports.curr_ports.nextcloud.web ];

  #services.postgresql.dataDir = PGdataDir;
  #services.onlyoffice.enable = true;
  services.nextcloud = {
    enable = true;
    hostName = "cloud.hannses.de";
    package = pkgs.nextcloud30;
    https = true;

    home = NCdataDir;

    config = {
      adminpassFile = config.age.secrets.nextcloud_adminpass.path;
      #dbtype = "pgsql";
    };
    database.createLocally = true; # automatically generate a pgsql db
    settings = {
      default_phone_region = "DE";
      trusted_domains = [ "*" ]; # TODO set trusted domains here
      enabledPreviewProviders = [
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\HEIC"
      ];
    };

    maxUploadSize = config.nextcloud_max_size;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit contacts
        #calendar
        #maps
        deck groupfolders bookmarks cospend notes polls;
    };
  };
}
