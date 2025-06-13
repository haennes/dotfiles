{ pkgs, lib, ... }:
let
  modprobe = lib.getExe' pkgs.kmod "modprobe";
  sudo = lib.getExe pkgs.sudo;
in ''
  ${sudo} ${modprobe} -r hid_multitouch
  ${sudo} ${modprobe} hid_multitouch
''
