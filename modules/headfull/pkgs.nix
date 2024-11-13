{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [

    #browser
    firefox
    brave
    tor-browser

    #media
    gimp # edit
    vlc # view

    #modelling
    freecad
    openscad-unstable
    prusa-slicer
    #kicad #cad for pcbs

    #office & texteditors
    libreoffice
    xournalpp # note taking
    obsidian # knowledge management
    helix

    #dicts
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US

    #formatting language
    tectonic # tex compiler
    texlive.combined.scheme-full # tex
    typst # typst
    typst-live # typst live preview browser

    #terminals
    alacritty
    blackbox-terminal

    #tools
    diff-pdf # pdf
    pdfarranger # pdf
    btop # process and system monitor
    unzip
    cifs-utils
    yubikey-manager-qt
    wl-clipboard # clipboard

    #tui
    bluetuith
    docker

    #programming
    tokei # count loc
    arduino
    arduinoOTA
    hugo # website
    cargo-generate
    rust-bin.nightly.latest.default
    python3
    ruff # python linter
    gcc # c compiler
    valgrind # c heap debugging

    #Gameing
    lutris # game launcher compatible with steam, wine, ...
    wineWowPackages.waylandFull

  ];
}
