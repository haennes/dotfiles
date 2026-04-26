{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.enable = mkEnableOption "office" // {
    default = osConfig.is_client;
  };
  import = [
    ./files
    ./rss.nix
    ./fonts.nix
    ./cliphist.nix
    ./flashcards.nix
    ./tasks.nix
    ./calc.nix
    ./finances.nix
  ];
}
