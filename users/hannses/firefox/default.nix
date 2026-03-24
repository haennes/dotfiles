{
  lib,
  pkgs,
  inputs,
  ...
}@hm_inputs:
let
  addons = pkgs.nur.repos.rycee.firefox-addons;
  favicon = domain: "https://${domain}/favicon.ico"; # TODO use this instead
  updateInterval = 24 * 60 * 60 * 1000; # every day
  engines_inputs = hm_inputs // {
    inherit favicon updateInterval;
  };
  settings = import ./settings.nix hm_inputs;
  engines = lib.my.recursiveMerge (
    lib.attrValues (
      inputs.haumea.lib.load {
        src = ./engines;
        inputs = engines_inputs;
        loader = inputs.haumea.lib.loaders.default;
      }
    )
  );
  search = {
    force = true;
    default = "ecosia";
    inherit engines;
  };
in
{
  programs.firefox = {
    enable = true;
    profiles = rec {
      default = {
        isDefault = true;
        extensions.packages = with addons; [
          # keep-sorted start
          clearurls
          darkreader
          floccus
          ipfs-companion
          keepassxc-browser
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
      spotify = {
        isDefault = false;
        id = 2;
        settings = settings.spotify;

      };
    };
  };
}
