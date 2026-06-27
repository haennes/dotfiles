{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.knowledgemgmt.enable = mkEnableOption "knowledgemgmt" // {
    default = config.my.office.enable;
  };
  imports = [
    ./zotero.nix
  ];
}
