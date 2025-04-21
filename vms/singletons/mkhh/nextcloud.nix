{ pkgs, config, ... }:
let
  group = "nexctloud";
  owner = "nexctloud";
  NCdataDir = "/persist/data";
in {
  age.secrets = {
    nextcloud_adminpass = {
      file = ../../../secrets/nextcloud_mkhh/adminpass.age;
      inherit group owner;
    };
  };

  system.activationScripts.ensure-dirs-exist = {
    deps = [ "users" "groups" ];
    text = ''
      mkdir -p ${NCdataDir}
      chown -R ${owner}:${group} ${NCdataDir}
    '';
  };

  networking.firewall.allowedTCPPorts =
    [ config.ports.ports.curr_ports.nextcloud.web ];

  services.nextcloud = {
    enable = true;
    hostName = "cloud.mkhh.hannses.de";
    package = pkgs.nextcloud31;
    https = true;
    configureRedis = true;
    home = NCdataDir;

    config = {
      adminpassFile = config.age.secrets.nextcloud_adminpass.path;
      dbtype = "sqlite";
    };
    database.createLocally = true; # automatically generate a sqlite db
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
      inherit contacts calendar
        #maps
        deck groupfolders bookmarks cospend notes polls;
    };
  };
}
