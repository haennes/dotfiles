{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./pdf.nix
    ./loc.nix
    ./prettifiers.nix
    ./archive.nix
    ./clipboard.nix
    ./fix_hid.nix
    ./ips_cli.nix
    ./ports_cli.nix
    ./ripgrep.nix
    ./eza.nix
    ./ncdu.nix
    ./lsof.nix
    ./networking.nix
    ./tldr.nix
    ./usbutils.nix
  ];

  options.my.utils.enable = mkEnableOption "utils" // {
    default = config.is_client;
  };

}
