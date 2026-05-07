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
  options.my.office.media.chromecast.enable = mkEnableOption "chromecast" // {
    default = config.my.office.media.enable;
  };
  config = mkIf config.my.office.media.chromecast.enable {
    networking.firewall = {
      allowedUDPPorts = [ 5353 ]; # For device discovery
      allowedUDPPortRanges = [
        {
          from = 32768;
          to = 61000;
        }
      ]; # For Streaming
      allowedTCPPorts = [ 8010 ]; # For gnomecast server
    };
    services.avahi.enable = true;
    environment.systemPackages = with pkgs; [
      (chromium.override {
        commandLineArgs = "--load-media-router-component-extension=1";
      })
    ];
  };
}
