{ pkgs, globals, ... }: ''

  ${pkgs.cliphist}/bin/cliphist wipe
  ${pkgs.wl-clipboard}/bin/wl-copy ""
''
