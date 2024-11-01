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
    ./pkgs.nix
    ./power.nix
    ./tasks.nix
    ./users.nix
    ./virtualization.nix
  ];

}
