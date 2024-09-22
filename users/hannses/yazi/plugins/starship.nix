{ yaziPlugins, lib, ... }: {
  name = "starship";
  pkg = yaziPlugins.starship;

  initLua = ''
    require("starship"):setup()
  '';
}
