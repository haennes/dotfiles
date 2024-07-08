{yaziPlugins, lib, ...}:{
  name = "starship";
  pkg = yaziPlugins.starship;

  initLua = ''
    require("starship"):setup()
  '';

  keymap = {
    manager = {
      prepend_keymap = [
          {
            on = ["<Enter>"];
            run = "plugin bypass --args=smart_enter";
            desc = "Open a file, or recursively enter child directory, skipping children with only a single subdirectory";
          }
          {
            on = ["l"];
            run = "plugin bypass --args=smart_enter";
            desc = "Open a file, or recursively enter child directory, skipping children with only a single subdirectory";
          }
          {
            on = ["h"];
            run = "plugin bypass --args=reverse";
            desc = "Recursively enter parent directory, skipping parents with only a single subdirectory";
          }
      ];
    };
  };
}
