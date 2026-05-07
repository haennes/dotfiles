{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #browser
    firefox
    brave
    tor-browser

    #kicad #cad for pcbs

    #formatting language
    #tectonic # tex compiler
    #texlive.combined.scheme-full # tex

    #terminals
    alacritty
    blackbox-terminal

    #programming
    arduino
    arduino-ota
    hugo # website
    rust-bin.nightly.latest.default
    # cargo-generate
    python3
    ruff # python linter
    gcc # c compiler
    gnumake
    cmake
    valgrind # c heap debugging

    #Gameing
    wineWow64Packages.waylandFull

  ];
}
