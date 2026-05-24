{ pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mum_dad";
  home.homeDirectory = "/home/mum_dad";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    signal-desktop
    lorien
  ];

}
