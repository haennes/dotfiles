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
  options.my.utils.backup.enable = mkEnableOption "backup" // {
    default = true;
  };
  config = mkIf config.my.utils.backup.enable {
    environment.systemPackages = with pkgs; [
      restic
    ];
  };
}
