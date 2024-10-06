{ osConfig, ... }: {
  services.udiskie = {
    enable = osConfig.services.udisks2.enable;
    notify = true;
    automount = false;
    settings = { program_options = { tray = true; }; };
  };
}
