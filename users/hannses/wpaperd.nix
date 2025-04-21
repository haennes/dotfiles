{ config, ... }: {
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "5m";
        mode = "stretch"; # TODO ix for rotated monitors
        path = config.home.homeDirectory + "/.wallpapers";
      };
    };
  };
}
