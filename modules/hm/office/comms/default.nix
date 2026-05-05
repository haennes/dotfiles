{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.comms.enable = mkEnableOption "communications" // {
    default = config.my.office.enable;
  };
  imports = [
    ./signal.nix
    ./matrix.nix
  ];
}
