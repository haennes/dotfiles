{
  lib,
  pkgs,
  inputs,
  config,
  ...
}@hm_inputs:
let
  inherit (lib) optional mkEnableOption mkIf;
  addons = pkgs.nur.repos.rycee.firefox-addons;
  settings = import ./settings.nix hm_inputs;
  search = {
    force = true;
    default = "ecosia";
    inherit (config.my.office.browsers.search) engines;
  };
in
{
  options.my.office.browsers.firefox =  {
    enable = mkEnableOption "firefox" // {
      default = config.my.office.browsers.enable;
    };
    autostart = {
      enable = mkEnableOption "firefox autostart" // {
        default = true;
      };
    };
  };
  config = mkIf config.my.office.browsers.firefox.enable {
    programs.firefox = {
      enable = true;
      profiles = rec {
        default = {
          isDefault = true;
          extensions.packages = with addons; [
            # keep-sorted start sticky_comments=no block=yes
            clearurls
            darkreader
            floccus
            ipfs-companion
            no-pdf-download
            passbolt
            tridactyl
            ublock-origin
            zotero-connector
            # keep-sorted end
          ];
          settings = settings.default;
          inherit search;
        };
        oth = default // {
          isDefault = false;
          id = 1;
        };
      };
    };
    my.office.browsers.specialWorkspace.autostart.autostart = (
      mkIf config.my.office.browsers.firefox.autostart.enable [ config.programs.firefox.package ]
    );
  };
}
