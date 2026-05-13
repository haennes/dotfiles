{
  pkgs,
  lib,
  config,
  ...
}:
{

  virtualisation.waydroid.enable = true;
  systemd.services.waydroid-container.wantedBy = lib.mkForce [ ];

}
