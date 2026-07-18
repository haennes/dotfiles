{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.my.office.cli.shell.smartcd.enable = mkEnableOption "zoxide smart cd" // {
    default = config.my.office.cli.shell.enable;
  };
  config = mkIf config.my.office.cli.shell.smartcd.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = config.programs.nushell.enable;
    };
  };
}
