{ ... }:
{
  imports = [
    ./utils
    ./hardware
    ./identity
    ./virtualization.nix
    ./desktop
    ./office
    ./state-version.nix
  ];
}
