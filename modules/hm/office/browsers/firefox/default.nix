{
  lib,
  pkgs,
  inputs,
  config,
  ...
}@hm_inputs:
let
  inherit (lib) optional;
  addons = pkgs.nur.repos.rycee.firefox-addons;
  settings = import ./settings.nix hm_inputs;
  search = {
    force = true;
    default = "ecosia";
    inherit (config.my.office.browsers.search) engines;
  };
in
{
  config = {
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
      optional config.my.office.browsers.firefox.autostart.enable [ config.programs.firefox.package ]
    );
  };
}
