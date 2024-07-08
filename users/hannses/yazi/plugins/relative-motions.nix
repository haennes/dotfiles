{yaziPlugins, lib, ...}:{
  name = "relative-motions";
  pkg = yaziPlugins.relative-motions;

  initLua = ''
    require("relative-motions"):setup({ show_numbers="relative", show_motion = true })
  '';

  keymap = {
    manager = {
      prepend_keymap = (lib.lists.map(idx_n:
           let
           idx = builtins.toString idx_n;
           in
           {
             on = [ idx ];
             run = "plugin relative-motions --args=${idx}";
             desc = "Move in relative steps";
           }) (lib.range 1 9));
    };
  };
}
