{ config, lib, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ../tasks.nix
    ./base.nix
    ./local_nginx.nix
    ./pkgs.nix
    # keep-sorted end
  ];

}
