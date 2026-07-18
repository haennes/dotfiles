{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.utils.fzf.enable = mkEnableOption "fzf" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.fzf.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
      enableNushellIntegration = config.programs.nushell.enable;
      historyWidget.command = "";
    };
  };
}
