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
  options.my.utils.usbutils.enable = mkEnableOption "usbutils" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.usbutils.enable {
    environment.systemPackages = with pkgs; [
      usbutils
    ];
  };
}
