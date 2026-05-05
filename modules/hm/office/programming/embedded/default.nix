{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.programming.embedded.enable = mkEnableOption "embedded helpers" // {
    default = config.my.office.programming.enable;
  };
  imports = [
    ./platformio.nix
  ];
}
