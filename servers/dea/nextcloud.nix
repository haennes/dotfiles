{
  pkgs,
  config,
  lib,
  ...
}:
let
  owner = config.services.syncthing.user;
  group = config.services.syncthing.group;
  NCdataDir = "/data/nextcloud";
  PGdataDir = "/data/pg";
  SCdataDir = config.services.syncthing.dataDir;
  IPFSdataDir = config.services.kubo.dataDir;
in
{

  age.secrets = {
    nextcloud_adminpass = {
      file = ../../secrets/nextcloud/adminpass.age;
      inherit group owner;
    };
  };

  users.users."nextcloud" = {
    isSystemUser = true;
    group = "nextcloud";
    uid = 994;
  };
  users.groups."nextcloud" = {
    gid = 993;
  };
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 204800;
  };
  services.syncthing = rec {
    user = "nextcloud";
    group = user;
  };
  systemd.services."nextcloud-setup".requires = [ "syncthing.service" ];
  systemd.services."nextcloud-setup".after = [ "syncthing.service" ];

  system.activationScripts.ensure-dirs-exist = {
    deps = [
      # keep-sorted start sticky_comments=no block=yes
      "groups"
      "users"
      # keep-sorted end
    ];
    text = ''
      mkdir -p ${NCdataDir}
      chown ${owner}:${group} ${NCdataDir} --quiet
      mkdir -p ${SCdataDir}
      chown ${owner}:${group} ${SCdataDir} --quiet
      mkdir -p ${IPFSdataDir}
      chown ${owner}:${group} ${IPFSdataDir} --quiet
    '';
  };
  #mkdir -p ${PGdataDir}
  #chown postgres:postgres ${PGdataDir}

  networking.firewall.allowedTCPPorts = [ config.ports.ports.curr_ports.nextcloud.web ];

  #services.postgresql.dataDir = PGdataDir;
  #services.onlyoffice.enable = true;
  services.nextcloud = {
    enable = true;
    hostName = "cloud.hannses.de";
    package = pkgs.nextcloud32;
    https = true;
    configureRedis = true;
    home = NCdataDir;

    config = {
      adminpassFile = config.age.secrets.nextcloud_adminpass.path;
      dbtype = "sqlite";
    };
    database.createLocally = true; # automatically generate a pgsql db
    settings = {
      default_phone_region = "DE";
      trusted_domains = [ "*" ]; # TODO set trusted domains here
      enabledPreviewProviders = [
        # keep-sorted start sticky_comments=no block=yes
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\HEIC"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MP3"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        # keep-sorted end
      ];
    };

    maxUploadSize = config.nextcloud_max_size;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit
        contacts
        calendar
        #maps
        deck
        groupfolders
        bookmarks
        cospend
        notes
        polls
        ;
    };
  };
}
