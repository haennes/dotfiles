{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    #formatting language
    #tectonic # tex compiler
    #texlive.combined.scheme-full # tex

    #terminals
    alacritty
    blackbox-terminal
  ];
}
