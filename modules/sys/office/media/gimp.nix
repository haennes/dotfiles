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
  options.my.office.media.gimp.enable = mkEnableOption "gimp" // {
    default = config.my.office.media.enable;
  };
  config = mkIf config.my.office.media.gimp.enable {
    environment.systemPackages = with pkgs; [
      gimp
    ];
  };
}
