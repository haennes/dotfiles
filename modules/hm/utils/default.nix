{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./clipboard.nix
    ./pdf.nix
    ./ffmpeg.nix
    ./tuis
  ];
  options.my.utils.enable = mkEnableOption "utils" // {
    default = osConfig.my.utils.enable;
  };
}
