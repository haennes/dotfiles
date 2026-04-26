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
  options.my.office.music.compose.enable = mkEnableOption "composing software" // {
    default = config.my.office.music.enable;
  };
  config = mkIf config.my.office.music.compose.enable {
    home.packages = with pkgs; [
      musescore
    ];
  };
}
