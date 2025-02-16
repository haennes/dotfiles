{ ... }: {
  services.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = false;
    #  pulse.enable = true;
    #  jack.enable = true;
    #  alsa.enable = true;
    #  alsa.support32Bit = true;
  };
}
