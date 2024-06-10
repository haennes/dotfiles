{ pkgs, permit_pkgs, rust-bin, ... }: {
  environment.systemPackages = with pkgs; [
    firefox
    brave
    tor-browser
    gimp
    freecad
    openscad
    prusa-slicer
    libreoffice
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    tectonic
    texlive.combined.scheme-full
    typst
    typst-live
    xournalpp
    hugo
    cargo-generate
    vlc
    alacritty
    blackbox-terminal
    pdfarranger
    python3
    rust-bin.nightly.latest.default
    gcc
    ruff
    helix
    tokei
    permit_pkgs.obsidian
    wl-clipboard
    zoom-us
    cifs-utils
    yubikey-manager-qt
    bluetuith
    btop
    docker
    unzip
    arduino
    arduinoOTA
  ];
}
