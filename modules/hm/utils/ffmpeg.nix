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
  options.my.utils.ffmpeg.enable = mkEnableOption "ffmpeg" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.ffmpeg.enable {
    home.packages = with pkgs; [
      ffmpeg
    ];
  };
}
