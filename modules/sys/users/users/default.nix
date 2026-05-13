{ ... }:
{
  # having a "primitive" group inside the user spec is allowed
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ./dad.nix
    ./forward.nix
    ./hannses.nix
    ./mum.nix
    ./root.nix
    # keep-sorted end
  ];
}
