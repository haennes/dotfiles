{ config, lib, hports, ... }: {
  imports = [
    ./base.nix
    ./pkgs.nix
    ./minecraft
    ./tasks.nix
    ./homepage-dashboard.nix
    ./local_nginx.nix
    ./atuin.nix
    ./fortivpn.nix
    ./virtualization.nix
  ];
  services.postgresql.settings.port =
    lib.mkIf (hports ? postresql) hports.postgresql;

}
