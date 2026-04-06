{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./pdf.nix
    ./loc.nix
  ];

  options.my.utils.enable = mkEnableOption "utils" // {
    default = config.is_client;
  };

}
