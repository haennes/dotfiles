{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.programming.lang.sasm.enable = mkEnableOption "sasm" // {
    default = config.my.office.programming.lang.enable;
  };
  config = mkIf config.my.office.programming.lang.sasm.enable {
    home.packages = [
      inputs.sasm.legacyPackages.x86_64-linux.default
    ];
  };
}
