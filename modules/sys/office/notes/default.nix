{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.notes.enable = mkEnableOption "note taking apps and WSGI editors" // {
    default = config.is_client;
  };
  imports = [
    ./libreoffice.nix
    ./xournalpp.nix
  ];
}
