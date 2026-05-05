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
  options.my.office.programming.license-cli.enable =
    mkEnableOption "license texts on the command line"
    // {
      default = config.my.office.programming.enable;
    };
  config = mkIf config.my.office.programming.license-cli.enable {
    home.packages = with pkgs; [ license-cli ];
  };
}
