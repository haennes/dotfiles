{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.media.enable = mkEnableOption "media viewing and editing" // {
    default = config.is_client;
  };
  imports = [
    ./gimp.nix
    ./vlc.nix
    ./audio.nix
  ];
}
