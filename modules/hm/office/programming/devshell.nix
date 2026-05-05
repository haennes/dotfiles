{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.programming.devshell.enable = mkEnableOption "direnv devshell" // {
    default = config.my.office.programming.enable;
  };
  config = mkIf config.my.office.programming.devshell.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
  };
}
