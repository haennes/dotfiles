{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  #"/etc/nixpkgs/channel/nixpkgs";
  nix-serve-publicKey_raw = import ../../secrets/nix-serve/dea/pub.nix;
  nix-serve-publicKey = lib.last (lib.splitString ":" nix-serve-publicKey_raw);
  optionalIfNotDea = opt: lib.optional (config.networking.hostName != "dea") opt;
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
        substituters = [
          "https://hyprland.cachix.org?priority=10"
          "https://nix-community.cachix.org?priority=5"
        ]
        # ++ (optionalIfNotDea
        #   "http://nix-serve.local.hannses.de?priority=20" # http is fine, since it is inside the wg0 network
        # )
        ;
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nix-serve.local.hannses.de:${nix-serve-publicKey}"
        ];
        # Make ready for nix flakes
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        connect-timeout = 5;
        log-lines = 25;

        trusted-users = [
          "forward"
          "hannses"
        ];
      };
      daemonIOSchedPriority = 7;
      daemonIOSchedClass = "idle";
      daemonCPUSchedPolicy = "batch";

    };
    programs.nh = {
      enable = true;
      flake = "/home/hannses/.dotfiles?submodules=1";
    };
  };
}
