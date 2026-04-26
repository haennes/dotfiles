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
  options.my.utils.clipboard.enable = mkEnableOption "clipboard" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.clipboard.enable {
    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
