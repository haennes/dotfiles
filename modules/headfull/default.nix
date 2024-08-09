{ config, lib, ... }: {
  imports = [ ./base.nix ./pkgs.nix ./tasks.nix ./homepage-dashboard.nix ./local_nginx.nix ./atuin.nix ./fortivpn.nix ./virtualization.nix];

}
