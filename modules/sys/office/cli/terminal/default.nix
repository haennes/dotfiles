{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.cli.terminal.enable = mkEnableOption "terminal" // {
    default = config.is_client;
  };
  imports = [
    ./alacritty.nix
    ./blackbox.nix
  ];
}
