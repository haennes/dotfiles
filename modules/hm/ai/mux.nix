{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.ai.mux.enable = mkEnableOption "multiplexer for ai agents" // {
    default = config.my.ai.enable;
  };
  config = mkIf config.my.ai.mux.enable {
    programs.herdr = {
      enable = true;
    };
  };
}
