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
  options.my.office.browsers.brave.enable = mkEnableOption "brave" // {
    default = config.my.office.browsers.enable;
  };
  config = mkIf config.my.office.browsers.brave.enable {
    environment.systemPackages = with pkgs; [
      brave
    ];
  };
}
