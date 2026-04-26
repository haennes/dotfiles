{ config, lib, ... }:
let
  inherit (lib) mkEnableOption;
in

{
  imports = [
    ./nh.nix
    ./nix-search.nix
    ./nix-diff.nix
    ./nix-tree.nix
    ./nix-inspect.nix
  ];
  options.my.utils.nix.enable = mkEnableOption "nix" // {
    default = config.my.utils.enable;
  };
}
