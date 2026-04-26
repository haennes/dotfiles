{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./btop.nix
    ./bluetooth.nix
  ];
  options.my.utils.tuis.enable = mkEnableOption "tuis" // {
    default = config.my.utils.enable;
  };
}
