{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.utils.nix.nix-inspect.enable = mkEnableOption "nix-inspect" // {
    default = config.my.utils.nix.enable;
  };
  config = mkIf config.my.utils.nix.nix-inspect.enable {
    home.packages = with pkgs; [
      inputs.nix-inspect.packages.${system}.default
    ];
  };
}
