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
  options.my.utils.ncdu.enable = mkEnableOption "ncdu" // {
    default = config.my.utils.enable;
  };

  config = mkIf config.my.utils.ncdu.enable {
    environment.systemPackages = with pkgs; [
      ncdu
    ];
  };

}
