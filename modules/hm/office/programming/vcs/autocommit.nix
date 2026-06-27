{
  lib,
  config,
  system,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.programming.vcs.autocommit.enable = mkEnableOption "autocommit" // {
    default = config.my.office.programming.vcs.enable && config.my.office.programming.vcs.git.enable;
  };
  config = mkIf config.my.office.programming.vcs.autocommit.enable {
    home.packages = [
      inputs.savepoint.packages.${system}.default
    ];
  };
}
