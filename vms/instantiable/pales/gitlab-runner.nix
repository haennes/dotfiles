{
  lib,
  config,
  pkgs,
  ...
}:
{
  age.secrets = {
    gitlab-runner-token-file = {
      file = ../../../secrets/gitlabrunners/pales_1/token.age;
    };
  };

  environment.systemPackages = config.services.gitlab-runner.extraPackages;

  services.gitlab-runner = {
    enable = true;

    services = {
      zock-1 = {
        # dockerImage = "nixos/nix";
        executor = "shell";
        authenticationTokenConfigFile = config.age.secrets.gitlab-runner-token-file.path;
      };
    };

    extraPackages = with pkgs; [
      # keep-sorted start
      catch2_3
      cmake
      doxygen
      gcc
      gnumake
      python3
      screen
      valgrind
      # keep-sorted end
    ];
  };
  systemd.services.gitlab-runner.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "gitlab-runner";
    Group = "gitlab-runner";
  };
  users.users.gitlab-runner = {
    home = "/var/lib/gitlab-runner";
    group = "gitlab-runner";

    isNormalUser = true;
  };
  users.groups.gitlab-runner = { };
}
