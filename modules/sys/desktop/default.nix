{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.desktop.enable = mkEnableOption "desktop environments" // {
    default = config.is_client;
  };

  imports = [
    ./hyprland.nix
    ./portal.nix
    ./monitors.nix
  ];

}
