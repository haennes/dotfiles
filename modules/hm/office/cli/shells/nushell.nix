{
  config,
  pkgs,
  lib,
  scripts,
  globals,
  joint-standalone,
  ...
}:
let
  home = config.home.homeDirectory;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.cli.shells.nushell.enable = mkEnableOption "z shell" // {
    default = config.my.office.cli.shells.enable;
  };
  config = mkIf config.my.office.cli.shells.nushell.enable {
    programs.nushell = {
      enable = true;
    };
  };
}
