{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.knowledgemgmt.zotero.enable = mkEnableOption "zotero citing" // {
    default = config.my.office.knowledgemgmt.enable;
  };
  config = mkIf config.my.office.knowledgemgmt.zotero.enable {
    home.packages = with pkgs; [ inputs.nixpkgs-stable.legacyPackages.x86_64-linux.zotero ];
  };
}
