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
    package = pkgs.nextcloud28;
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

    maxUploadSize = "2G";
    #notify_push.enable = true;
    #configureRedis = true;
    #caching.redis = true;
    #autoUpdateApps.enable = true;
    #extraOptions.trusted_domains = [ "*.local" ];
    extraApps = with config.services.nextcloud.package.packages.apps; {

      inherit contacts calendar deck groupfolders maps bookmarks cookbook
        cospend forms mail notes onlyoffice polls tasks;
      memories = pkgs.fetchNextcloudApp {
        sha256 = "sha256-Xr1SRSmXo2r8yOGuoMyoXhD0oPVm/0/ISHlmNZpJYsg=";
        url =
          "https://github.com/pulsejet/memories/releases/download/v6.2.2/memories.tar.gz";
        license = "lgpl3"; # should be agpl but not in set anymore ??
      };
      familytree = pkgs.fetchNextcloudApp {
        sha256 = "sha256-Lj20mNni8XxWSij1p7IvjC6PdhkEtWcglc1BwZuPHlc=";
        url =
          "https://github.com/derbenx/nextcloud-familytree/releases/download/1.3.5/familytree.tar.gz";
        license = "lgpl3"; # see abouve
      };
      #news = pkgs.fetchNextcloudApp {
      #  sha256 = "sha256-cfJkKRNSz15L4E3w1tnEb+t4MrVwVzb8lb6vCOA4cK4=";
      #  url = "https://github.com/nextcloud/news/releases/download/24.0.0/news.tar.gz";
      #  license = "agpl3";
      #};
      #integration_google = pkgs.fetchNextcloudApp {
      #sha256 = "sha256-ZOeuJ8DQr36mUt9svHmc+wJ46qof7kxKyZP9WcEtgTs=";
      #url = "https://github.com/nextcloud/integration_google/releases/download/v1.0.9/integration_google-1.0.9.tar.gz";
      #license = "agpl3";
      #};
    };
    # extraAppsEnable = true;
    #notify_push.enable = true;
    #configureRedis = true;
  };
}
