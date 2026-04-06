{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./pdf.nix
    ./loc.nix
    ./prettifiers.nix
    ./archive.nix
    ./clipboard.nix
  ];

  options.my.utils.enable = mkEnableOption "utils" // {
    default = config.is_client;
  };

}
