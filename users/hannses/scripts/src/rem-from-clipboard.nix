{ pkgs, globals, ... }: ''

    DMENU="${globals.dmenu}"
    cliphist="${pkgs.cliphist}/bin/cliphist"

    $cliphist list | $DMENU | $cliphist delete
  ''
