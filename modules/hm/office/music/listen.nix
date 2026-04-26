{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.music.listen.enable = mkEnableOption "listening to music software" // {
    default = config.my.office.music.enable;
  };
  config = mkIf config.my.office.music.listen.enable {
    home.packages = with pkgs; [
      shortwave
    ];
  };
}
