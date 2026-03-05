{ config, ... }: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      wallpaper = [{
        timeout = 5 * 60;
        fit_mode = "cover";
        path = config.home.homeDirectory + "/.wallpapers";
      }];
    };
  };
}
