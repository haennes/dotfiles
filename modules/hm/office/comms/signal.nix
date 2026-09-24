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
  options.my.office.comms.signal = {
    enable = mkEnableOption "signal messenger" // {
      default = config.my.office.comms.enable;
    };
    autostart = {
      enable = mkEnableOption "autostart" // {
        default = true;
      };
    };
  };
  config = mkIf config.my.office.comms.signal.enable {
    home.packages = with pkgs; [
      signal-desktop
      scli # signal tui FIXME replace with gurk-rs as soon as upstream fixed
      signal-cli
    ];
    my.office.comms.specialWorkspace.autostart.autostart = (
      optional config.my.office.comms.signal.autostart.enable [pkgs.signal-desktop]
    );
  };
}
