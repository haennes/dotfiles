{ config, lib, ... }:
let
  inherit (lib) mkEnableOption;
in

{
  imports = [
    ./nh.nix
    ./nix-search.nix
    ./nix-diff.nix
  ];
  options.my.utils.nix.enable = mkEnableOption "nix" // {
    default = config.my.utils.enable;
  };
}
