{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) any attrValues;
in
{
  boot.kernelPackages =
    if (any (v: v.fsType == "zfs") (attrValues config.fileSystems)) then
      config.boot.zfs.package.latestCompatibleLinuxPackages
    else
      pkgs.linuxPackages;

}
