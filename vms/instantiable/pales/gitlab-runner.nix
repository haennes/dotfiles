{ config, ... }: {
  age.secrets = {
    gitlab-runner-token-file = {
      file = ../../../secrets/gitlabrunners/pales_1/token.age;
    };
  };

  services.gitlab-runner = {
    enable = true;

    services = {
      zock-1 = {
        # dockerImage = "nixos/nix";
        executor = "shell";
        authenticationTokenConfigFile =
          config.age.secrets.gitlab-runner-token-file.path;
      };
    };
  };
}
