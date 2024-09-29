{ yaziPlugins, ... }: {
  name = "full-border";
  pkg = yaziPlugins.full-border;

  initLua = ''
    require("full-border"):setup()
  '';
}
