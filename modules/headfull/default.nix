{ config, lib, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ../tasks.nix
    ./base.nix
    ./hyprland.nix
    ./local_nginx.nix
    ./pg_dev.nix
    ./pkgs.nix
    ./virtualization.nix
    # keep-sorted end
  ];

}
