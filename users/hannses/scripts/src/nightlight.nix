{ globals, lib, ... }: ''
  DMENU="${globals.dmenu}"
  case "$( echo -e '${lib.concatStringsSep "\\n" [ "off" "on" ]}' | $DMENU)" in
    "off")
      systemctl --user stop wlsunset.service
    ;;
    "on")
      systemctl --user start wlsunset.service
    ;;
  esac
''
