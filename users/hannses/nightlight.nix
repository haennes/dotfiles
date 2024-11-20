{ ... }: {
  services.wlsunset = {
    enable = true;
    temperature = {
      day = 851;
      night = 850;
    };
    longitude = 10;
    latitude = 50;
  };
}
