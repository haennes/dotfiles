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
  options.my.office.media.vimiv.enable = mkEnableOption "vimiv media player" // {
    default = config.my.office.media.enable;
  };
  config = mkIf config.my.office.media.vimiv.enable {
    home.packages = with pkgs; [ vimiv-qt ];
  };
}
