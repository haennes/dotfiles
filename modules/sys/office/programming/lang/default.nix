{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.programming.lang.enable = mkEnableOption "languages" // {
    default = config.my.office.programming.enable;
  };
  imports = [
    ./rust.nix
    ./python.nix
  ];
}
