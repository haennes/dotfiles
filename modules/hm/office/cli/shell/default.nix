{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.cli.shell.enable = mkEnableOption "shell utils and more" // {
    default = config.my.office.cli.enable;
  };
  imports = [
    ./aliases.nix
    ./ssh.nix
    ./prompt.nix
    ./history.nix
    ./completion.nix
    ./smartcd.nix
    ./fzftui.nix
  ];
}
