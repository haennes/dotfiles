{ pkgs, scripts, globals, ... }: {
  typst-live-custom = pkgs.pkgs.writeShellScript "typst-watch-to-typst-live" ''
    #typst-live $1
    #firefox ~/Downloads/04*.pdf
    touch /home/hannses/alive.txt
  '';
}
