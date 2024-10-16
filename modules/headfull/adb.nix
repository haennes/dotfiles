{ pkgs, ... }: {
  programs.adb.enable = true;
  users.users.hannses.extraGroups = [ "adbusers" "kvm" ];
  services.udev.packages = with pkgs; [ android-udev-rules ];
}
