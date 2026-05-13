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
  options.my.virtualization.virtualbox.enable = mkEnableOption "orcacle virtual box" // {
    default = config.is_client;
  };
  config = mkIf config.my.virtualization.virtualbox.enable {
    virtualisation.virtualbox.host.enable = true;

    users.extraGroups = lib.mkIf config.virtualisation.virtualbox.host.enable {
      vboxusers.members = [ "hannses" ];
    };
    # virtualisation.virtualbox.host.enableExtensionPack = true;
  };
}
