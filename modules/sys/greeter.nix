{ config, ... }:
{
  services.displayManager.ly = {
    enable = !config.services.desktopManager.gnome.enable && config.is_client;
    settings = {
      # animation = "none";
      save = true;
      load = true;
      blank = true;
    };
  };
}
