{ pkgs, ... }: { environment.systemPackages = with pkgs; [ plantuml-c4 ]; }
