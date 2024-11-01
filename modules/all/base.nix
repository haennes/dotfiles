{ config, lib, ... }: {
  config = {
    boot.tmp.cleanOnBoot = true;
    system.stateVersion = "23.11"; # Did you read the comment?

    networking.firewall.enable = true;
  };
}
