{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #browser
    brave

    #formatting language
    #tectonic # tex compiler
    #texlive.combined.scheme-full # tex

    #terminals
    alacritty
    blackbox-terminal
  ];
}
