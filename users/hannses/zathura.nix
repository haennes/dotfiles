{ ... }: {
  programs.zathura = {
    enable = true;

    options = {
      # use actual clipboard as default doesn't seem to work on Wayland
      selection-clipboard = "clipboard";
    };
  };
}
