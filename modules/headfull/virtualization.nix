{
  pkgs,
  lib,
  config,
  ...
}:
{

  # dont build virtualbox
  virtualisation.virtualbox.host.enable = true;

  users.extraGroups = lib.mkIf config.virtualisation.virtualbox.host.enable {
    vboxusers.members = [ "hannses" ];
  };
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  virtualisation.waydroid.enable = true;
  systemd.services.waydroid-container.wantedBy = lib.mkForce [ ];

}
