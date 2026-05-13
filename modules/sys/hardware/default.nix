{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.hardware.enable = mkEnableOption "hardware specific options" // {
    default = !config.is_microvm;
  };

  imports = [
    ./power.nix
    ./fwupd.nix
    ./secure-boot.nix
    ./switches.nix
    ./printing.nix
    ./bluetooth.nix
    ./wifi.nix
  ];

}
