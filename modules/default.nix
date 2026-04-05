{ ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ./adb.nix
    ./all
    ./gnome
    ./headfull
    ./headless
    ./home_manager
    # keep-sorted end
  ];
}
