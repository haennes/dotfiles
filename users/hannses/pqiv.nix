{ ... }: {
  programs.pqiv = {
    enable = true;

    settings = {
      options = {
        lazy-load = 1;
        hide-info-box = 1;
        background-pattern = "black";
        thumbnail-size = "256x256";
        command-1 = "dolphin"; # TODO!!! globals
      };
    };
  };
}
