{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.markup.enable = mkEnableOption "markup languages" // {
    default = config.my.office.enable;
  };
  imports = [
    ./typst.nix
    ./plantuml.nix
  ];
}
