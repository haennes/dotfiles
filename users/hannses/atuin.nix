{ osConfig, ... }: {

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "http://atuin.localhost";
      key_path = osConfig.age.secrets."atuin/key.age".path;
      session_path = osConfig.age.secrets."atuin/session.age".path;
    };
  };
}
