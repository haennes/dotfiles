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
  options.my.identity.keepassxc.enable = mkEnableOption "keepassxc" // {
    default = config.my.identity.enable;
  };
  config = mkIf config.my.identity.keepassxc.enable {
    home.packages = with pkgs; [
      keepassxc
    ];
  };
}
