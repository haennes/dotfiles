{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (!config.is_microvm) {
    boot.binfmt.emulatedSystems = lib.lists.filter (sys: pkgs.stdenv.hostPlatform.system != sys) [
      # keep-sorted start sticky_comments=no block=yes
      "aarch64-linux"
      "x86_64-linux"
      # keep-sorted end
    ];
  };
}
