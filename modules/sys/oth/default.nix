{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.oth.enable = mkEnableOption "oth configs" // {
    default = config.is_client;
  };

  imports = [
    ./oth-files.nix
  ];

}
