{ config, lib, pkgs, ... }: {
  config = lib.mkIf (!config.is_microvm) {
    boot.binfmt.emulatedSystems =
      lib.lists.filter (sys: pkgs.stdenv.hostPlatform.system != sys) [
        "x86_64-linux"
        "aarch64-linux"
      ];
  };
}
