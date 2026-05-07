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
  options.my.office.programming.lang.python.enable = mkEnableOption "python" // {
    default = config.my.office.programming.lang.enable;
  };
  config = mkIf config.my.office.programming.lang.python.enable {
    environment.systemPackages = with pkgs; [
      python3
      ruff # python linter
    ];
  };
}
