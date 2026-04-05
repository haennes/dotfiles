{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.graphics.enable = mkEnableOption "graphics" // {
    # default = config.is_client;
    default = true;
  };
  config = mkIf config.my.graphics.enable {
    hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };
}
