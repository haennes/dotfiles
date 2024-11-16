{ ... }: {
  services.wlsunset = {
    enable = true;
    temperature = {
      day = 51;
      night = 50;
    };
    longitude = 10;
    latitude = 50;
  };
}
