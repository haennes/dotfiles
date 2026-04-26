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
    ./nix
    ./diff.nix
  ];
  options.my.utils.enable = mkEnableOption "utils" // {
    default = osConfig.my.utils.enable;
  };
}
