{
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.virtualization.enable = mkEnableOption "virtualization" // {
    default = osConfig.programs.virt-manager.enable;
  };

  config = mkIf config.my.virtualization.enable {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
