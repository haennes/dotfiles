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
  options.my.office.programming.hugo.enable = mkEnableOption "hugo website builder" // {
    default = config.my.office.programming.enable;
  };
  config = mkIf config.my.office.programming.hugo.enable {
    environment.systemPackages = with pkgs; [
      hugo # website
    ];
  };
}
