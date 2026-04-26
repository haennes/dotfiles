{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.music.enable = mkEnableOption "music" // {
    default = config.my.office.enable;
  };
  imports = [
    ./compose.nix
  ];
}
