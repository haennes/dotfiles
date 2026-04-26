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
  options.my.utils.diff.enable = mkEnableOption "diff" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.diff.enable {
    home.packages = with pkgs; [
      icdiff
    ];
  };
}
