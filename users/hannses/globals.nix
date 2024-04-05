{ pkgs, ... }:
#TODO use ${} 
with pkgs; {
  term = "alacritty";
  dmenu = "rofi -dmenu -i";
  app_runner = "rofi -show drun";
  browser = "firefox";
  image = "pqiv";
  video = "mpv";
  pdf = "zathura";
  docs = "libreoffice-fresh";
  archive = "p7zip";
}
