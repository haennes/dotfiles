{ config, ... }:
{
  services.displayManager.ly = {
    enable = !config.services.desktopManager.gnome.enable;
    settings = {
      # animation = "none";
      save = true;
      load = true;
      blank = true;
    };
  };
}
