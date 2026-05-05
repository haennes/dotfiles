{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.programming.vcs.enable = mkEnableOption "Version contorl systems" // {
    default = config.my.office.programming.enable;
  };
  imports = [
    ./git.nix
  ];
}
