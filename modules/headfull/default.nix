{ config, lib, ... }:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ../tasks.nix
    ./adb.nix
    ./audio.nix
    ./base.nix
    ./chromecast.nix
    ./dll.nix
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
    ./power.nix
    ./printing.nix
    ./steam.nix
    ./virtualization.nix
    ./wireshark.nix
    ./xdg.nix
    ./yubikey.nix
    # keep-sorted end
  ];

}
