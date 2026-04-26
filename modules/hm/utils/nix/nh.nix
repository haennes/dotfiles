{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.my.utils.nix.nh = {
    enable = mkEnableOption "nh" // {
      default = osConfig.my.utils.nix.enable;
    };
    config = mkOption {
      type = types.anything;
      default = osConfig.programs.nh;
    };
  };
  config = mkIf config.my.utils.nix.nh.enable {
    programs.nh = config.my.utils.nix.nh.config;
    home.packages = with pkgs; [
      update-apply-cycle
    ];
  };
}
