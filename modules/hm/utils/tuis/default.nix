{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./btop.nix
  ];
  options.my.utils.tuis.enable = mkEnableOption "tuis" // {
    default = config.my.utils.enable;
  };
}
