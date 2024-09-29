{ yaziPlugins, ... }: {
  name = "chmod";
  pkg = yaziPlugins.chmod;

  keymap = {
    manager = {
      prepend_keymap = {
        on = [ "c" "m" ];
        run = "plugin chmod";
        desc = "Chmod on selected files";
      };
    };
  };
}
