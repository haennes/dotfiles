{
  config,
  pkgs,
  ...
}:
let
  secret = name: config.age.secrets."signal-whisper/${name}".path;
in
{
  age.secrets."signal-whisper/accounts.json" = {
    file = ../../secrets/signal-whisper/accounts.json.age;
  };
  age.secrets."signal-whisper/account.db" = {
    file = ../../secrets/signal-whisper/account.db.age;
    owner = config.services.signal-whisper.user;
    group = config.services.signal-whisper.user;
  };
  age.secrets."signal-whisper/config.json" = {
    file = ../../secrets/signal-whisper/config.json.age;
  };
  age.secrets."signal-whisper/account" = {
    file = ../../secrets/signal-whisper/account.age;
  };

  services.signal-whisper = {
    enable = true;
    model = "${pkgs.large-v3-q5_0}/large-v3-q5_0.bin";
    language = "de";
    secrets = {
      accountsFile = secret "accounts.json";
      accountFile = secret "account";
      accountDbFile = secret "account.db";
      configFile = secret "config.json";
    };
  };
}
