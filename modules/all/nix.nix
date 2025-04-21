{ inputs, pkgs, lib, config, ... }:
let
  channelPath = "/nix/var/nix/profiles/per-user/root/channels";
  #"/etc/nixpkgs/channel/nixpkgs";
  nix-serve-publicKey_raw = import ../../secrets/nix-serve/dea/pub.nix;
  nix-serve-publicKey = lib.last (lib.splitString ":" nix-serve-publicKey_raw);
  optionalIfNotDea = opt:
    lib.optional (config.networking.hostName != "dea") opt;
in {
  nix = {
    package = pkgs.nix;
    settings = {
      substituters =
        [ "https://hyprland.cachix.org" "https://nix-community.cachix.org" ]
        ++ (optionalIfNotDea
          "http://nix-serve.local.hannses.de"); # http is fine, since it is inside the wg0 network
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-serve.local.hannses.de:${nix-serve-publicKey}"
      ];
      # Make ready for nix flakes
      experimental-features = [ "nix-command" "flakes" ];
      connect-timeout = 5;
      log-lines = 25;
    };
    registry.nixpkgs.flake = inputs.nixpkgs;

    nixPath = [
      "nixpkgs=${channelPath}"
      #"/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
  systemd.tmpfiles.rules =
    [ "L+ ${channelPath}     - - - - ${inputs.nixpkgs}" ];
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d";
      dates = "daily";
    };
  };
}
