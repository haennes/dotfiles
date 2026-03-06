{
  hm-config,
  lib,
  pkgs,
  ...
}:
#TODO use ${}
let
  home = hm-config.home.homeDirectory;
  inherit (lib) getExe;
  inherit (pkgs) wezterm rofi;
in
rec {
  execute_term = "${term} start";
  term = "${getExe wezterm}";
  dmenu = "${getExe rofi} -dmenu -i";
  app_runner = "${getExe rofi} -show drun";
  browser = "firefox";
  image = "pqiv";
  video = "mpv";
  pdf = "zathura";
  docs = "libreoffice-fresh";
  archive = "p7zip";
  filemanager = "yazi";
  dotfiles_path = "${home}/.dotfiles";
}
