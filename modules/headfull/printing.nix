{ pkgs, ... }: {
  services.printing = {
    drivers = [ pkgs.gutenprint ];
    enable = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
