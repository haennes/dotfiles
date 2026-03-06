{ pkgs, ... }:
''
  state=$(${pkgs.dunst}/bin/dunstctl is-paused)    
  case "$state" in
  "true")
    echo -e ""
  ;;
  "false")
    echo -e ""
  ;;
  esac

''
