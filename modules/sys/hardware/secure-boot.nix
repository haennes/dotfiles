{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.hardware.secure-boot.enable = mkEnableOption "secure boot helpers" // {
    default = config.is_client;
  };
  config = mkIf config.my.hardware.secure-boot.enable {
    environment.systemPackages = with pkgs; [
      sbctl
    ];
  };
}
