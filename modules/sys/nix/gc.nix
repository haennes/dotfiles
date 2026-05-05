{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.nix.gc.enable = mkEnableOption "when to garbage collect the nix store" // {
    default = !config.is_microvm;
  };
  config = mkIf config.my.nix.gc.enable {
    programs.nh.clean = {
      enable = true;
      extraArgs = "--keep-since 4d";
      dates = "daily";
    };
  };
}
