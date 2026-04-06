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
  options.my.utils.loc.enable = mkEnableOption "lines of code util" // {
    default = config.my.utils.enable;
  };

  config = mkIf config.my.utils.loc.enable {
    environment.systemPackages = with pkgs; [
      tokei
    ];
  };
}
