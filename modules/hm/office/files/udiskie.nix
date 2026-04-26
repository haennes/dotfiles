{
  osConfig,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.files.udiskie.enable = mkEnableOption "udiskie" // {
    default = osConfig.services.udisks2.enable;
  };
  config = mkIf config.my.office.files.udiskie.enable {
    services.udiskie = {
      enable = true;
      notify = true;
      automount = false;
      settings = {
        program_options = {
          tray = true;
        };
      };
    };
  };
}
