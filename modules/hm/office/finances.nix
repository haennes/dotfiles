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
  options.my.office.finance.enable = mkEnableOption "finance management" // {
    default = config.my.office.enable;
  };
  config = mkIf config.my.office.finance.enable {
    home.packages = with pkgs; [
      portfolio
    ];
  };
}
