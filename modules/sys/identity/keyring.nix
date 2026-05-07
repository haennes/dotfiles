{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.identity.keyring.enable = mkEnableOption "gnome keyring" // {
    default = config.my.identity.enable;
  };
  config = mkIf config.my.identity.keyring.enable {
    services.gnome.gnome-keyring.enable = false;
  };
}
