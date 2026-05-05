{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.media.mpv.enable = mkEnableOption "mpv media player" // {
    default = config.my.office.media.enable;
  };
  config = mkIf config.my.office.media.mpv.enable {
    programs.mpv = {
      enable = true;
      scripts = [ pkgs.mpvScripts.mpris ];
    };
  };
}
