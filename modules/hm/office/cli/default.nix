{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.cli.enable = mkEnableOption "cli" // {
    default = config.my.office.enable;
  };
  imports = [
    ./terminal
    ./shells
    ./shell
    ./mux
  ];
}
