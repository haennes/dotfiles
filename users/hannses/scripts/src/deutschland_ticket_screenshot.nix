{ pkgs, hm-config, ... }:
let home = hm-config.home.homeDirectory;
in ''
  ${pkgs.feh}/bin/feh -FZ ${home}/Documents/DeutschlandTicket.png
''
