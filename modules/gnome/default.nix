{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf config.services.xserver.desktopManager.gnome.enable {
    services.xserver = {
      enable = true;
      xkb = {
        layout = "de";
        variant = "nodeadkeys";
      };
      displayManager.gdm.enable = true;
    };
    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
        gnome-console
        cheese # webcam tool
        epiphany # web browser
        geary # email reader
        yelp # Help view
      ])
      ++ (with pkgs.gnome; [
        gnome-music
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        gnome-contacts
        gnome-initial-setup
      ]);
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [ gnome-tweaks ];
  };
}
