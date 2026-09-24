{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optional;
in
{
  options.my.office.comms.matrix = {
    enable = mkEnableOption "matrix messenger" // {
      default = config.my.office.comms.enable;
    };
    autostart = {
      enable = mkEnableOption "autostart" // {
        default = true;
      };
    };
  };
  config = mkIf config.my.office.comms.matrix.enable {
    home.packages = with pkgs; [
      element-desktop
    ];
    my.office.comms.specialWorkspace.autostart.autostart = (
      optional config.my.office.comms.matrix.autostart.enable [pkgs.element-desktop]
    );
  };
}
