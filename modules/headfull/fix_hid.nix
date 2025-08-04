{ pkgs, lib, ... }:
let modprobe = lib.getExe' pkgs.kmod "modprobe";
in {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "fix_hid" ''
      ${modprobe} -r hid_multitouch
      ${modprobe} hid_multitouch
    '')
  ];
}
