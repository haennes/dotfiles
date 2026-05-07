{ config, lib, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ../tasks.nix
    ./base.nix
    ./hyprland.nix
    ./local_nginx.nix
    ./minecraft.nix
    ./pg_dev.nix
    ./pkgs.nix
    ./steam.nix
    ./virtualization.nix
    # keep-sorted end
  ];

}
