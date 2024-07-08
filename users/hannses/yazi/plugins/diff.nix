{yaziPlugins, lib, ...}:{
  name = "diff";
  pkg = yaziPlugins.diff;

  keymap = {
    manager = {
      prepend_keymap = {
        on   = [ "D" ];
        run  = "plugin diff";
        desc = "Diff the selected with the hovered file";
      };
    };
  };
}
