{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.nix.nh.enable = mkEnableOption "wether to configure nh nix helper" // {
    default = !config.is_microvm;
  };
  config = mkIf config.my.nix.nh.enable {
    programs.nh = {
      enable = true;
      flake = "/home/hannses/.dotfiles?submodules=1";
    };
  };
}
