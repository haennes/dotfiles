{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.files.enable = mkEnableOption "files" // {
    default = config.my.office.enable;
  };
  imports = [
    ./bookmarks.nix
    ./yazi.nix
  ];
}
