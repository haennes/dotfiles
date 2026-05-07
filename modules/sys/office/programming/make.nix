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
  options.my.office.programming.make.enable = mkEnableOption "make and make like tools" // {
    default = config.my.office.programming.enable;
  };
  config = mkIf config.my.office.programming.make.enable {
    environment.systemPackages = with pkgs; [
      gnumake
      cmake
    ];
  };
}
