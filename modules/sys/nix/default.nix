{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.nix.enable = mkEnableOption "nix base settings" // {
    default = true;
  };

  imports = [
    ./nix.nix
    ./store-optimize.nix
    ./crosscompile.nix
    ./distributed-builds.nix
    ./gc.nix
    ./channel.nix
  ];

}
