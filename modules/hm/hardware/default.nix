{ osConfig, lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./powerntfy.nix
  ];
  options.my.hardware.enable = mkEnableOption "networking" // {
    default = !osConfig.is_microvm;
  };

}
