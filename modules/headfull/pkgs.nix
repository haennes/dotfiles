{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #browser
    firefox
    brave
    tor-browser

    #formatting language
    #tectonic # tex compiler
    #texlive.combined.scheme-full # tex

    #terminals
    alacritty
    blackbox-terminal

    #programming
    python3
    ruff # python linter
    gcc # c compiler
    gnumake
    cmake
    valgrind # c heap debugging
  ];
}
