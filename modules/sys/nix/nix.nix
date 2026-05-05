{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  #"/etc/nixpkgs/channel/nixpkgs";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.nix.nix.enable = mkEnableOption "core config for nix" // {
    default = config.my.nix.enable;
  };
  config = mkIf config.my.nix.nix.enable {
    nix = {
      package = if (pkgs.stdenv.hostPlatform.system != "aarch64-linux") then pkgs.lix else pkgs.nix;
      settings = {
        # Make ready for nix flakes
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        connect-timeout = 5;
        log-lines = 25;

      };
      daemonIOSchedPriority = 7;
      daemonIOSchedClass = "idle";
      daemonCPUSchedPolicy = "batch";

    };
  };
}
