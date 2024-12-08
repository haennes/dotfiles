{ ... }: {
  services.wlsunset = {
    enable = true;
    temperature = {
      day = 4850;
      night = 3900;
    };
    longitude = 10;
    latitude = 50;
  };
}
