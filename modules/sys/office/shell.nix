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
  options.my.office.shell.enable = mkEnableOption "basic shell" // {
    default = true;
  };

  config = mkIf config.my.office.shell.enable {
    # Set up zsh
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    # Set up starship
    #TODO determine if this changes ANYTHING
    programs.starship.enable = true;
  };
}
