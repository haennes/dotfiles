{ pkgs, ... }: {
  programs.adb.enable = true;
  users.users.hannses.extraGroups = [ "adbusers" "kvm" ];
}
