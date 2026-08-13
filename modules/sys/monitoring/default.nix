{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.monitoring.enable = mkEnableOption "identity" // {
    default = true;
  };

  imports = [
    ./rot.nix
  ];

}
