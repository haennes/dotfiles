{ config, lib, ... }: {
  config = lib.mkIf (!config.is_microvm) { services.fwupd.enable = true; };
}
