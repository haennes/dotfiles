{ config, lib, ... }:
let
  inherit (lib) mkEnableOption;
in

{
  imports = [
    ./nh.nix
  ];
  options.my.utils.nix.enable = mkEnableOption "nix" // {
    default = config.my.utils.enable;
  };
}
