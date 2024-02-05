{pkgs, permit_pkgs, ...}: {
environment.systemPackages = with pkgs; [
  firefox
  brave
  tor-browser
  gimp
  freecad
  prusa-slicer
  libreoffice
  hunspell
  hunspellDicts.de_DE
  hunspellDicts.en_US
  tectonic
  texlive.combined.scheme-full
  typst
  typst-live
  hugo
  cargo-generate
  vlc
  alacritty
  blackbox-terminal
  pdfarranger
  python3
  ruff
  helix
  loc
  permit_pkgs.obsidian
  ];
}
