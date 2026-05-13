{
  config,
  lib,
  inputs,
  ...
}:
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
    ./virtmanager.nix
    ./virtualbox.nix
    inputs.microvm.nixosModules.microvm
    inputs.microvm.nixosModules.host
  ];

  options.my.virtualization.enable = mkEnableOption "virtualization" // {
    default = !config.is_microvm;
  };
  config.microvm = {
    guest.enable = config.is_microvm;
    host.enable = config.is_microvm_host;
  };
}
