{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.enable = mkEnableOption "office" // {
    default = osConfig.is_client;
  };
  imports = [
    ./files
    ./rss.nix
    ./fonts.nix
    ./cliphist.nix
    ./flashcards.nix
    ./tasks.nix
    ./calc.nix
    ./finances.nix
    ./music
    ./cli
    ./markup
    ./editors
    ./media
    ./programming
    ./comms
    ./browsers
    ./draw.nix
    ./knowledgemgmt
  ];
}
