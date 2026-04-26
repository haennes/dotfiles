{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./clipboard.nix
  ];
  options.my.utils.enable = mkEnableOption "utils" // {
    default = osConfig.my.utils.enable;
  };
}
