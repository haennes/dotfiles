{ lib, pkgs, ... }@old_inputs:
let
  inputs = old_inputs // { inherit (pkgs) yaziPlugins; };
  # TODO should this be automated ? (probably only after in flake...)
  # haumea ???
  #lib.map (plugin: {
  #plugins."${plugin.name}" = plugin.pkg;
  #} // (lib.removeAttrs plugin ["name" "pkg"]))
in [
  (import ./relative-motions.nix inputs)
  (import ./bypass.nix inputs)
  (import ./starship.nix inputs)
  (import ./jump-to-char.nix inputs)
  (import ./chmod.nix inputs)
  (import ./smart-filter.nix inputs)
  (import ./hide-preview.nix inputs)

  (import ./full-border.nix inputs)
  (import ./max-preview.nix inputs)

]
