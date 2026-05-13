{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.virtualization.android.enable = mkEnableOption "waydroid android emulation" // {
    default = config.is_client;
  };
  config = mkIf config.my.virtualization.android.enable {
    virtualisation.waydroid.enable = true;
    systemd.services.waydroid-container.wantedBy = lib.mkForce [ ];

  };
}
