{ lib, pkgs, inputs, ... }@hm_inputs:
let
  addons = pkgs.nur.repos.rycee.firefox-addons;
  favicon = domain: "https://${domain}/favicon.ico"; # TODO use this instead
  updateInterval = 24 * 60 * 60 * 1000; # every day
  engines_inputs = hm_inputs // { inherit favicon updateInterval; };
  settings = import ./settings.nix hm_inputs;
in {
  programs.firefox = {
    enable = true;
    profiles = rec {
      default = {
        isDefault = true;
        extensions.packages = with addons; [
          tridactyl
          ublock-origin
          floccus
          keepassxc-browser
          darkreader
          ipfs-companion
          passbolt
          clearurls
        ];
        settings = settings.default;
        search = {
          force = true;
          default = "ecosia";
          engines = lib.my.recursiveMerge (lib.attrValues
            (inputs.haumea.lib.load {
              src = ./engines;
              inputs = engines_inputs;
              loader = inputs.haumea.lib.loaders.default;
            }));
        };
      };
      oth = default // {
        isDefault = false;
        id = 1;
      };
    };
  };
}
