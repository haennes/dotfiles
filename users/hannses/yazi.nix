{ pkgs, inputs, ... }: {
  imports = [
    (inputs.nix-yazi-plugins.legacyPackages.x86_64-linux.homeManagerModules.default)
  ];
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      show_hidden = false;
      sort_dir_first = false;
      sort_sensitive = false;
      sort_by = "natural"; # Sort naturally, e.g. 1.md < 2.md < 10.md
    };
  };

  programs.yazi.yaziPlugins = {
    enable = true;
    plugins = {
      bypass.enable = true;

      smart-enter.enable = true;
      git.enable = true;
      glow.enable = true;

      chmod.enable = true;
      full-border.enable = true;
      hide-preview.enable = true;
      starship.enable = true;
      jump-to-char = {
        enable = true;
        keys.toggle.on = [ "F" ];
      };
      bookmarks = {
        persist = "all";
        enable = true;
      };
      open-with-cmd.enable = true;
      max-preview.enable = true;
      smart-filter.enable = true;
      relative-motions = {
        enable = true;
        show_numbers = "relative_absolute";
        show_motion = true;
      };
      #fg.enable = true;
    };
  };
}
