{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.modelling.enable = mkEnableOption "modelling software" // {
    default = config.is_client;
  };
  imports = [
    ./openscad.nix
    ./freecad.nix
  ];
}
