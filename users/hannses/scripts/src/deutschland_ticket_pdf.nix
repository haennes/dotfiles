{ pkgs, hm-config, ... }:
let home = hm-config.home.homeDirectory;
in ''
  ${pkgs.zathura}/bin/zathura --mode=fullscreen ${home}/Documents/DeutschlandTicket.pdf
''
