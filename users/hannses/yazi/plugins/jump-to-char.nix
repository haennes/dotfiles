{ yaziPlugins, ... }: {
  name = "jump-to-char";
  pkg = yaziPlugins.jump-to-char;

  keymap = {
    manager = {
      prepend_keymap = {
        on = [ "f" ];
        run = "plugin jump-to-char";
        desc = "Jump to char";
      };
    };
  };
}
