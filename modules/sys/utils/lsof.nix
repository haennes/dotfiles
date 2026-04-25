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
  options.my.utils.lsof.enable = mkEnableOption "lsof" // {
    default = config.my.utils.enable;
  };

  config = mkIf config.my.utils.lsof.enable {
    environment.systemPackages = with pkgs; [
      lsof
    ];
  };

}
