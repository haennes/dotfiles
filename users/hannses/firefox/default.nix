{ lib, pkgs, inputs, ... }@hm_inputs:
let
  addons = pkgs.nur.repos.rycee.firefox-addons;
  favicon = domain: "https://${domain}/favicon.ico"; # TODO use this instead
  updateInterval = 24 * 60 * 60 * 1000; # every day
  engines_inputs = hm_inputs // { inherit favicon updateInterval; };
in {
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      extensions.packages = with addons; [
        tridactyl
        ublock-origin
        floccus
        keepassxc-browser
        darkreader
        ipfs-companion
        passbolt
      ];
      settings = {
        "browser.link.open_newwindow.restriction" = 0;
        "signon.rememberSignons" = false;
      };
      search = {
        force = true;
        default = "ecosia";
        engines = lib.my.recursiveMerge (lib.attrValues
          (inputs.haumea.lib.load {
            src = ./engines;
            inputs = engines_inputs;
            loader = inputs.haumea.lib.loaders.default;
          }));

        #(import ./alto.nix engines_inputs)
        #// (import ./bahn.nix engines_inputs)
        #// (import ./fdroid.nix engines_inputs)
        #// (import ./github.nix engines_inputs)
        #// (import ./icons.nix engines_inputs)
        #// (import ./mail.nix engines_inputs)
        #// (import ./models.nix engines_inputs)
        #// (import ./nix.nix engines_inputs)
        #// (import ./programming.nix engines_inputs)
        #// (import ./social.nix engines_inputs)
        #// (import ./typst.nix engines_inputs)
        #// (import ./websearch.nix engines_inputs)
        #// (import ./wikipedia.nix engines_inputs)
        #;
      };
    };
  };
}
