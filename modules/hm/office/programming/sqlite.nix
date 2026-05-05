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
  options.my.office.programming.sqlite.enable = mkEnableOption "test database" // {
    default = config.my.office.programming.enable;
  };
  config = mkIf config.my.office.programming.sqlite.enable {
    home.packages = with pkgs; [ sqlite ];
  };
}
