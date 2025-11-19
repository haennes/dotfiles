{ globals, lib, ... }: ''
  DMENU="${globals.dmenu}"
  case "$( echo -e '${
    lib.concatStringsSep "\\n" [ "start" "stop" ]
  }' | $DMENU)" in
    "start")
      systemctl --user start waybar
    ;;
    "stop")
      systemctl --user stop waybar
    ;;
  esac
''
