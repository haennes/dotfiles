{ config, lib, ... }: {
  imports = [
    ./adb.nix
    ./audio.nix
    ./base.nix
    ./fortivpn.nix
    ./homepage-dashboard.nix
    ./hyprland.nix
    ./local_nginx.nix
    ./mail.nix
    ./minecraft.nix
    ./steam.nix
    ./pkgs.nix
    ./power.nix
    ./users.nix
    ./virtualization.nix
    ../tasks.nix
    ./pg_dev.nix
    ./chromecast.nix
    ./printing.nix
  ];

}
