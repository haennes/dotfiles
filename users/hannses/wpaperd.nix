{config, pkgs, ...}:{
  programs.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "5m";
        # mode = "center";
        path = config.home.homeDirectory+"/.wallpapers";
      };
    };
  };
}
