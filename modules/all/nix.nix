{ pkgs, ... }: {
  nix = {
    package = pkgs.nix;
    settings = {
      substituters =
        [ "https://hyprland.cachix.org" "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      # Make ready for nix flakes
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
