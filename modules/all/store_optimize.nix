{ lib, config, ... }:
lib.mkIf (!config.is_microvm) {
  nix.optimise = {
    automatic = true;
    dates = [ "13:15" ];
  };
  nix.gc = {
    automatic = true;
    persistent = true; # ensure trigger if sleeping at $dates
    dates = "19:00";
    options = "--delete-older-than 14d";
  };
}
