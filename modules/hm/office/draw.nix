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
  options.my.office.draw.enable = mkEnableOption "draw management" // {
    default = config.my.office.enable;
  };
  config = mkIf config.my.office.draw.enable {
    home.packages = with pkgs; [
      lorien
    ];
  };
}
