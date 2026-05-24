{
  lib,
  pkgs,
  inputs,
  config,
  ...
}@hm_inputs:
let
  addons = pkgs.nur.repos.rycee.firefox-addons;
  settings = import ./settings.nix hm_inputs;
  search = {
    force = true;
    default = "ecosia";
    inherit (config.my.office.browsers.search) engines;
  };
in
{
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
          keepassxc-browser
          no-pdf-download
          passbolt
          tridactyl
          ublock-origin
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
}
