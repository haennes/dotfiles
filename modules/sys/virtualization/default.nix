{ config, lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./docker.nix
  ];

  options.my.virtualization.enable = mkEnableOption "virtualization" // {
    default = !config.is_microvm;
  };
}
