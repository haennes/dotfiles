{ pkgs, lib, ... }@inputs:
let
  plugins = import ./plugins inputs;
  recursiveMerge = listOfAttrsets:
    lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) { } listOfAttrsets;
in {
  #TODO make similar to https://github.com/lordkekz/dotfiles/blob/ecbc485609d5dc76ff2f386a216957801d0ad58c/homeProfiles/terminal/yazi.nix
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.yazi;
    settings = {
      show_hidden = false;
      sort_dir_first = false;
      sort_sensitive = false;
      sort_by = "natural"; # Sort naturally, e.g. 1.md < 2.md < 10.md
    };
    plugins = (with pkgs.yaziPlugins; { })
      // lib.mergeAttrsList (lib.map (p: { "${p.name}" = p.pkg; }) plugins);
    initLua = lib.concatStringsSep "\n"
      (map (p: if p ? initLua then p.initLua else "") plugins);

    #TODO recursiveMerge fails as it does not combine lists... maybe write sth myself or move it to a flake all together. for now this works
    #implement other plugins first
    # mkMerge might be the thing we want
    #recursiveMerge (lib.flatten ((map(p: p.keymap) plugins) ++[{
    keymap.manager = {
      prepend_keymap = lib.flatten (lib.map
        (p: if p ? keymap then p.keymap.manager.prepend_keymap else [ ])
        plugins) ++ [

        ];
    };
    #}]));
  };
}
