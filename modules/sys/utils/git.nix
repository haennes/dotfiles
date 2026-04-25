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
  options.my.utils.git.enable = mkEnableOption "git" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.git.enable {
    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
