{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./ntfyd.nix
  ];
  options.my.desktop.enable = mkEnableOption "desktop" // {
    default = osConfig.is_client;
  };
}
