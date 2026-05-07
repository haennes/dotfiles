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
  options.my.office.media.vlc.enable = mkEnableOption "vlc" // {
    default = config.my.office.media.enable;
  };
  config = mkIf config.my.office.media.vlc.enable {
    environment.systemPackages = with pkgs; [
      vlc
    ];
  };
}
