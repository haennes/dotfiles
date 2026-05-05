{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.nix.store-optimize.enable = mkEnableOption "when to optimize the nix store" // {
    default = !config.is_microvm;
  };
  config = mkIf config.my.nix.store-optimize.enable {
    nix.optimise = {
      automatic = true;
      dates = [ "13:15" ];
    };
  };
}
