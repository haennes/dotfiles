{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.cli.terminal.enable = mkEnableOption "terminals" // {
    default = config.my.office.cli.enable;
  };
  imports = [
    ./kitty.nix
    ./wezterm.nix
  ];

  config.home.sessionVariables.TERMINAL = "wezterm";
}
