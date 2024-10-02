{ globals, scripts, lib, ... }: ''
  DMENU="${globals.dmenu}"
  case "$( echo -e '${
    lib.concatStringsSep "\\n" [ "browser" "pdf" "screenshot" ]
  }' | $DMENU)" in
    "browser")
      ${scripts.deutschland_ticket_firefox}
    ;;
    "pdf")
      ${scripts.deutschland_ticket_pdf}
    ;;
    "screenshot")
      ${scripts.deutschland_ticket_screenshot}
    ;;
  esac
''
