{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.media.zathura.enable = mkEnableOption "zathura media viewer" // {
    default = config.my.office.media.enable;
  };
  config = mkIf config.my.office.media.zathura.enable {
    programs.zathura = {
      enable = true;

      options = {
        # use actual clipboard as default doesn't seem to work on Wayland
        selection-clipboard = "clipboard";
      };
    };
  };
}
