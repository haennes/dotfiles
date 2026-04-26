{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.cli.terminal.kitty.enable = mkEnableOption "kitty terminal" // {
    default = config.my.office.cli.terminal.enable;
  };
  config = mkIf config.my.office.cli.terminal.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        background_opacity = 0.8;
      };
    };
  };
}
