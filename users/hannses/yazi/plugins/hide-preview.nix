{ yaziPlugins, ... }: {
  name = "hide-preview";
  pkg = yaziPlugins.hide-preview;

  keymap = {
    manager = {
      prepend_keymap = {
        on = [ "T" ];
        run = "plugin hide-preview";
        desc = "Hide or show preview";
      };
    };
  };
}
