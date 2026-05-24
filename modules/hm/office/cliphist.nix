{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.cliphist.enable = mkEnableOption "cliphist" // {
    default = config.my.office.enable;
  };
  config = mkIf config.my.office.cliphist.enable {
    services.cliphist = {
      enable = true;

      systemdTargets = [ "graphical-session.target" ];
    };
  };
}
