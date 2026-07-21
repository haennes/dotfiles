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
  options.my.utils.tuis.btop.enable = mkEnableOption "btop" // {
    default = config.my.utils.tuis.enable || (config.is_server && !config.is_microvm);
  };
  config = mkIf config.my.utils.tuis.btop.enable {
    environment.systemPackages = with pkgs; [
      btop
    ];
  };
}
