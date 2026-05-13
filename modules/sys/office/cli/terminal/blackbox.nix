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
  options.my.office.cli.terminal.blackbox.enable = mkEnableOption "blackbox" // {
    default = config.my.office.cli.terminal.enable;
  };
  config = mkIf config.my.office.cli.terminal.blackbox.enable {
    environment.systemPackages = with pkgs; [
      blackbox-terminal
    ];
  };
}
