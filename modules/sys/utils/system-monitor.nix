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
  options.my.utils.system-monitor.enable = mkEnableOption "system-monitor" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.system-monitor.enable {
    environment.systemPackages = with pkgs; [
      btop # process and system monitor
      fastfetch # display system information
    ];
  };
}
