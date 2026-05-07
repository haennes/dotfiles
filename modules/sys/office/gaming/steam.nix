{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.gaming.steam.enable = mkEnableOption "steam" // {
    default = config.my.office.gaming.enable;
  };
  config = mkIf config.my.office.gaming.steam.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = (
          pkgs: [
            pkgs.corefonts
            pkgs.vista-fonts
          ]
        );
      };
    };
  };
}
