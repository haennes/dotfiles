{ ... }:
{
  imports = [
    ./users
    ./watchers
    ./services
    ./kernel.nix
    ./udisks.nix
    ./greeter.nix
    ./age.nix
    ./tmp.nix
    ./state-version.nix
  ];
}
