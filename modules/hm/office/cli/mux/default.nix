{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.cli.mux.enable = mkEnableOption "terminal mutliplexers" // {
    default = config.my.office.cli.enable;
  };
  imports = [
    ./tmux.nix
  ];
}
