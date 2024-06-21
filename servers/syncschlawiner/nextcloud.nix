{ pkgs, config, lib, sshkeys, ... }:
with lib; {

  age.secrets.nextcloud_adminpass = {
    file = ../../secrets/nextcloud/adminpass.age;
    owner = "nextcloud";
    group = "nextcloud";
  };

  #services.onlyoffice.enable = true;
  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    package = pkgs.nextcloud29;
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

    maxUploadSize = "4G";
    #notify_push.enable = true;
    #configureRedis = true;
    #caching.redis = true;
    #autoUpdateApps.enable = true;
    #extraOptions.trusted_domains = [ "*.local" ];
    extraApps = with config.services.nextcloud.package.packages.apps; {

      inherit contacts calendar deck groupfolders maps bookmarks cookbook
        cospend forms notes polls;
    };
    # extraAppsEnable = true;
    #notify_push.enable = true;
    #configureRedis = true;
  };
}
