{ pkgs, ... }: {
  services.printing = {
    drivers = [ pkgs.gutenprint pkgs.hplip pkgs.canon-cups-ufr2 ];
    enable = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
