{ pkgs, globals, ... }: ''

  DMENU="${globals.dmenu}"
  cliphist="${pkgs.cliphist}/bin/cliphist"

  sel=$($cliphist list | $DMENU)

  echo "$sel" | $cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
  echo "$sel" | $cliphist decode
''

