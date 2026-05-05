{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.nix.crosscompile.enable = mkEnableOption "configure cross compilation" // {
    default = !config.is_microvm;
  };
  config = mkIf config.my.nix.crosscompile.enable {
    boot.binfmt.emulatedSystems = lib.lists.filter (sys: pkgs.stdenv.hostPlatform.system != sys) [
      # keep-sorted start sticky_comments=no block=yes
      "aarch64-linux"
      "x86_64-linux"
      # keep-sorted end
    ];
  };
}
