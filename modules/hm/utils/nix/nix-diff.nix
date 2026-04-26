{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.utils.nix.nix-diff.enable = mkEnableOption "nix-diff" // {
    default = config.my.utils.nix.enable;
  };
  config = mkIf config.my.utils.nix.nix-diff.enable {
    home.packages = with pkgs; [
      nix-diff

    ];
  };
}
