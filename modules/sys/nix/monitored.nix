{ lib, config, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.nix.monitored.enable = mkEnableOption "wether to automatically pipe to nom" // {
    default = !config.is_microvm;
  };
  imports = [ inputs.nix-monitored.nixosModules.default ];
  config = mkIf config.my.nix.monitored.enable {
    nix.monitored = {
      enable = true;
      notify = true;
    };
  };
}
