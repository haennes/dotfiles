{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.my.office.cli.mux.zellij.enable = mkEnableOption "zellij terminal multiplexer" // {
    default = config.my.office.cli.mux.enable;
  };
  config = mkIf config.my.office.cli.mux.zellij.enable {
    environment.systemPackages = with pkgs; [
      zellij # terminal multiplexer
    ];
  };
}
