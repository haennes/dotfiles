{ lib, pkgs, inputs, ... }@hm_inputs:
let
  addons = pkgs.nur.repos.rycee.firefox-addons;
  recursiveMerge = listOfAttrsets:
    lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) { } listOfAttrsets;
  favicon = domain: "https://${domain}/favicon.ico"; # TODO use this instead
  updateInterval = 24 * 60 * 60 * 1000; # every day
  engines_inputs = hm_inputs // { inherit favicon updateInterval; };
in {
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      extensions = with addons; [
        tridactyl
        ublock-origin
        floccus
        keepassxc-browser
        darkreader
        ipfs-companion
      ];
      settings = { "browser.link.open_newwindow.restriction" = 0; };
      search = {
        force = true;
        default = "ecosia";
        engines = recursiveMerge (lib.attrValues (inputs.haumea.lib.load {
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
