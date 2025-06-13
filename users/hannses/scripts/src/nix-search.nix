{pkgs, lib, ...}:
let
nix-search-tv =  lib.getExe pkgs.nix-search-tv;
fzf = lib.getExe pkgs.fzf;
in
''
${nix-search-tv} print | ${fzf} --preview '${nix-search-tv} preview {}' --scheme history
''
