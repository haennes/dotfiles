{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) bool;
in {
  options = {
    is_server = mkOption {
      description = "Wether this is a server";
      type = bool;
      default = false;
      #default = config.is_microvm; #automatically set by the functions inside flake.nix
    };
    is_client = mkEnableOption "Wether this is a client" // { default = true; };
    is_laptop = mkEnableOption "Wether this is a laptop" // {
      default = false;
    };
    has_battery = mkEnableOption "Wether the device has an battery" // {
      default = config.is_laptop;
    };
    is_microvm_host = mkEnableOption "Wether this is a client";
    is_microvm = mkOption {
      description = "Wether this is a client";
      type = bool;
      default = false;
    };
  };
}
