{ config, lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./docker.nix
    ./microvm_guest.nix
    ./microvm_host.nix
    ./microvm_host_stock.nix
    ./microvm_host_systemd.nix
  ];

  options.my.virtualization.enable = mkEnableOption "virtualization" // {
    default = !config.is_microvm;
  };
}
