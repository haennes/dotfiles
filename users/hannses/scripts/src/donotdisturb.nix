{ globals, scripts, lib, pkgs, ... }: ''
  DMENU="${globals.dmenu}"
  case "$( echo -e '${
    lib.concatStringsSep "\\n" [ "MUTE" "UNMUTE" ]
  }' | $DMENU)" in
    "MUTE")
      ${pkgs.dunst}/bin/dunstctl set-paused true
    ;;
    "UNMUTE")
      ${pkgs.dunst}/bin/dunstctl set-paused false
    ;;
  esac
''
