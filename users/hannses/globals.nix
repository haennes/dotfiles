{ hm-config, ... }:
#TODO use ${}
let home = hm-config.home.homeDirectory;
in {
  term = "alacritty";
  dmenu = "rofi -dmenu -i";
  app_runner = "rofi -show drun";
  browser = "firefox";
  image = "pqiv";
  video = "mpv";
  pdf = "zathura";
  docs = "libreoffice-fresh";
  archive = "p7zip";
  filemanager = "yazi";
  dotfiles_path = "${home}/.dotfiles";
}
