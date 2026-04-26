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
  options.my.utils.nix.nix-tree.enable = mkEnableOption "nix-tree" // {
    default = config.my.utils.nix.enable;
  };
  config = mkIf config.my.utils.nix.nix-tree.enable {
    home.packages = with pkgs; [
      nix-tree
    ];
  };
}
