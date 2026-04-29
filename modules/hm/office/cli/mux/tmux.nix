{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.my.office.cli.mux.tmux.enable = mkEnableOption "tmux terminal multiplexer" // {
    default = config.my.office.cli.mux.enable;
  };
  config = mkIf config.my.office.cli.mux.tmux.enable {
    programs.tmux.enable = true;
  };
}
