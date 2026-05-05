{ config, lib, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ../tasks.nix
    ./audio.nix
    ./base.nix
    ./chromecast.nix
    ./fortivpn.nix
    ./hyprland.nix
    ./keyring.nix
    ./local_nginx.nix
    ./mail.nix
    ./minecraft.nix
    ./oth_files.nix
    ./pg_dev.nix
    ./pkgs.nix
    ./plantuml.nix
    ./printing.nix
    ./steam.nix
    ./virtualization.nix
    ./wireshark.nix
    ./yubikey.nix
    # keep-sorted end
  ];

}
