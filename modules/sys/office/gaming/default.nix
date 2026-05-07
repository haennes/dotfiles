{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.gaming.enable = mkEnableOption "gaming related software" // {
    default = config.is_client;
  };
  imports = [
    ./wine.nix
  ];
}
