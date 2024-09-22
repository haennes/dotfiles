{ yaziPlugins, lib, ... }: {
  name = "max-preview";
  pkg = yaziPlugins.max-preview;

  keymap = {
    manager = {
      prepend_keymap = {
        on = [ "R" ];
        run = "plugin --sync max-preview";
        desc = "Maximize or restore preview";
      };
    };
  };
}
