{ config, lib, pkgs, ... }: {
  config = lib.mkIf
    (!config.is_microvm && pkgs.stdenv.hostPlatform.system != "aarch64-linux") {
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    };
}
