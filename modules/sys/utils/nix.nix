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
  options.my.utils.nix.enable = mkEnableOption "nix" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.nix.enable {
    environment.systemPackages = with pkgs; [
      nix-output-monitor # better visualization of nix-shell and nix-build
      nixfmt # formatting nix files
    ];
  };
}
