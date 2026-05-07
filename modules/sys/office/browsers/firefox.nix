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
  options.my.office.browsers.firefox.enable = mkEnableOption "firefox" // {
    default = config.my.office.browsers.enable;
  };
  config = mkIf config.my.office.browsers.firefox.enable {
    environment.systemPackages = with pkgs; [
      firefox
    ];
  };
}
