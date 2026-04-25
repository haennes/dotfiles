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
  options.my.utils.deploy-rs.enable = mkEnableOption "deploy-rs" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.deploy-rs.enable {
    environment.systemPackages = with pkgs; [
      deploy-rs
    ];
  };
}
