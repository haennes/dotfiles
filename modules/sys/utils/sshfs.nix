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
  options.my.utils.sshfs.enable = mkEnableOption "sshfs" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.sshfs.enable {
    environment.systemPackages = with pkgs; [
      sshfs
    ];
  };
}
