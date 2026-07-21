{ ... }:
{
  imports = [
    ../../opts
    ./users
    ./watchers
    ./services
    ./kernel.nix
    ./udisks.nix
    ./greeter.nix
    ./age.nix
    ./tmp.nix
    ./state-version.nix
    ./graphics.nix
    ./i18n.nix
    ./networks
    ./virtualization
    ./utils
    ./ssh.nix
    ./hardware
    ./nix
    ./oth
    ./identity
    ./desktop
    ./office
  ];
}
