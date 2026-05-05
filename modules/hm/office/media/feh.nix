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
  options.my.office.media.feh.enable = mkEnableOption "feh media player" // {
    default = config.my.office.media.enable;
  };
  config = mkIf config.my.office.media.feh.enable {
    home.packages = with pkgs; [ feh ];
  };
}
