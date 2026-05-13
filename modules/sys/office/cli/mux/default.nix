{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.cli.mux.enable = mkEnableOption "terminal multiplexers" // {
    default = config.is_client;
  };
  imports = [
    ./tmux.nix
  ];
}
