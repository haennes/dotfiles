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
  options.my.office.cli.terminal.alacritty.enable = mkEnableOption "alacritty" // {
    default = config.my.office.cli.terminal.enable;
  };
  config = mkIf config.my.office.cli.terminal.alacritty.enable {
    environment.systemPackages = with pkgs; [
      alacritty
    ];
  };
}
