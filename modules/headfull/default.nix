{ config, lib, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ../tasks.nix
    ./audio.nix
    ./base.nix
    ./chromecast.nix
    ./hyprland.nix
    ./local_nginx.nix
    ./mail.nix
    ./minecraft.nix
    ./pg_dev.nix
    ./pkgs.nix
    ./plantuml.nix
    ./steam.nix
    ./virtualization.nix
    ./wireshark.nix
    ./yubikey.nix
    # keep-sorted end
  ];

}
