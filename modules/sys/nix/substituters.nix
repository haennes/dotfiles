{
  lib,
  config,
  nixConfig,
  ...
}:
let
  nix-serve-publicKey_raw = import ../../../secrets/nix-serve/dea/pub.nix;
  nix-serve-publicKey = lib.last (lib.splitString ":" nix-serve-publicKey_raw);
  inherit (lib) mkEnableOption mkIf;
  optionalIfNotDea = opt: lib.optional (config.networking.hostName != "dea") opt;

in
{
  options.my.nix.substituters.enable = mkEnableOption "get substituters from toplevel" // {
    default = config.my.nix.enable;
  };
  config = mkIf config.my.nix.substituters.enable {
    nix.settings = with nixConfig; {
      substituters = [
        "https://hyprland.cachix.org?priority=10"
        "https://nix-community.cachix.org?priority=5"
      ]
      ++ extra-substituters;
      # ++ (optionalIfNotDea
      #   "http://nix-serve.local.hannses.de?priority=20" # http is fine, since it is inside the wg0 network
      # )
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-serve.local.hannses.de:${nix-serve-publicKey}"
      ]
      ++ extra-trusted-public-keys;
      experimental-features = [
        "nix-command"
        "flakes"
      ]
      ++ extra-experimental-features;
    };
  };
}
