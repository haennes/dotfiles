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
  options.my.utils.fs.enable = mkEnableOption "fs" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.fs.enable {
    environment.systemPackages = with pkgs; [
      sshfs
      cifs-utils
    ];
  };
}
