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
  options.my.office.browsers.tor-browser.enable = mkEnableOption "tor-browser" // {
    default = config.my.office.browsers.enable;
  };
  config = mkIf config.my.office.browsers.tor-browser.enable {
    environment.systemPackages = with pkgs; [
      tor-browser
    ];
  };
}
