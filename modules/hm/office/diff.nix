{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.diff.enable = mkEnableOption "diff" // {
    default = config.my.office.enable;
  };
  config = mkIf config.my.office.diff.enable {
    programs.diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
