{ ... }: {
  specialisation = {
    gnome.configuration = {
      environment.etc."specialisation".text = "gnome";
      services.desktopManager.gnome.enable = true;
      services.gnome.gnome-remote-desktop.enable =
        false; # conflicts with pulsaudio
      system.nixos.tags = [ "gnome" ];
    };
  };
}
