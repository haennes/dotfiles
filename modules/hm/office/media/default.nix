{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.media.enable = mkEnableOption "media" // {
    default = config.my.office.enable;
  };
  imports = [
    ./mime.nix
    ./mpv.nix
  ];
}
