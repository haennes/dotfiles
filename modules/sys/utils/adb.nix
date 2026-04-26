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
  options.my.utils.adb.enable = mkEnableOption "adb" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.adb.enable {
    users.users.hannses.extraGroups = [
      # keep-sorted start sticky_comments=no block=yes
      "adbusers"
      "kvm"
      # keep-sorted end
    ];
  };
}
