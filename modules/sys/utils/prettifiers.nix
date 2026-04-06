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
  options.my.utils.prettifiers.enable = mkEnableOption "prettifiers util" // {
    default = config.my.utils.enable;
  };

  config = mkIf config.my.utils.prettifiers.enable {
    environment.systemPackages = with pkgs; [
      jq # json
    ];
  };
}
