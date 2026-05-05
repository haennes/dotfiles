{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.programming.enable = mkEnableOption "programming" // {
    default = config.my.office.enable;
  };
  imports = [
    ./devshell.nix
    ./vcs
    ./dbg
    ./license-cli.nix
    ./embedded
    ./lang
  ];
}
