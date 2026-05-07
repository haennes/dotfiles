{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.enable = mkEnableOption "office" // {
    default = config.is_client;
  };
  imports = [
    ./markup
    ./dictionaries.nix
    ./shell.nix
  ];
}
