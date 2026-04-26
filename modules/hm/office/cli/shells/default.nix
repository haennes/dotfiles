{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.cli.shells.enable = mkEnableOption "shells" // {
    default = config.my.office.cli.enable;
  };
  imports = [
    ./zsh.nix
  ];
}
