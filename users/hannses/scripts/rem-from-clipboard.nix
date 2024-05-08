{ pkgs, globals, ... }: {
  rem-from-clipboard = pkgs.pkgs.writeShellScript "rem-from-clipboard" ''

    DMENU="${globals.dmenu}"
    cliphist="${pkgs.cliphist}/bin/cliphist"

    $cliphist list | $DMENU | $cliphist delete 
  '';
}
