{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.media.audio.enable = mkEnableOption "audio" // {
    default = config.my.office.media.enable;
  };
  config = mkIf config.my.office.media.audio.enable {
    # rtkit is optional but recommended
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true; # if not already enabled
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
