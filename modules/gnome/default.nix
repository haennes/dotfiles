{pkgs, lib, ...}: with lib; 
{
    services.xserver = {
       enable = true;
       xkb = {
        layout = "de";
        variant = "nodeadkeys";
       };
       displayManager.gdm.enable = true;
       desktopManager.gnome.enable = true;
    };
    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
      gnome-console
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      epiphany # web browser
      geary # email reader
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      gnome-contacts
      gnome-initial-setup
    ]);
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
    ];
}
