{ yaziPlugins, lib, ... }: {
  name = "smart-filter";
  pkg = yaziPlugins.smart-filter;

  keymap = {
    manager = {
      prepend_keymap = {
        on = [ "F" ];
        run = "plugin smart-filter";
        desc = "Smart filter";
      };
    };
  };
}
