{ ... }:
{
  imports = [
    ./users
    ./watchers
    ./kernel.nix
    ./udisks.nix
    ./greeter.nix
  ];
}
