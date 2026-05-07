{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.editors.enable = mkEnableOption "text editors" // {
    default = config.my.office.enable;
  };
  imports = [
    ./helix.nix
  ];
}
