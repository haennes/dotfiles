{ ... }:
{
  # having a "primitive" group inside the user spec is allowed
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ./forward.nix
    # keep-sorted end
  ];
}
