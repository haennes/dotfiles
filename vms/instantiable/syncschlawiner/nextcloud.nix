{ pkgs, config, lib, ... }:
with lib; {

  age.secrets.nextcloud_adminpass = {
    file = ../../../secrets/nextcloud/adminpass.age;
    owner = "nextcloud";
    group = "nextcloud";
  };
  system.activationScripts.ensure-nextcloud-dir.text =
    let dir = config.services.nextcloud.home;
    in "mkdir -p ${dir} && chown nextcloud ${dir}";
  networking.firewall.allowedTCPPorts = [ 80 ];

  #services.onlyoffice.enable = true;
  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    package = pkgs.nextcloud30;
    https = true;

    home = "/data/nextcloud";

    config = { adminpassFile = config.age.secrets.nextcloud_adminpass.path; };
    settings = {
      default_phone_region = "DE";
      trusted_domains = [ "*" ];
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
    #notify_push.enable = true;
    #configureRedis = true;
    #caching.redis = true;
    #autoUpdateApps.enable = true;
    #extraOptions.trusted_domains = [ "*.local" ];
    extraApps = with config.services.nextcloud.package.packages.apps; {

      inherit contacts
        #calendar
        deck groupfolders
        #maps
        bookmarks cospend notes polls;
    };
    # extraAppsEnable = true;
    #notify_push.enable = true;
    #configureRedis = true;
  };
}
