{ config, lib, ... }:
{
  imports = [
    # keep-sorted start
    ../tasks.nix
    ./adb.nix
    ./audio.nix
    ./base.nix
    ./chromecast.nix
    ./dll.nix
    ./fix_hid.nix
    ./fortivpn.nix
    ./greeter.nix
    ./homepage-dashboard.nix
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
    ./users.nix
    ./virtualization.nix
    ./wireshark.nix
    ./xdg.nix
    ./yubikey.nix
    # keep-sorted end
  ];

}
