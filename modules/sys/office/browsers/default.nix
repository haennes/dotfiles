{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.browsers.enable = mkEnableOption "web browsers" // {
    default = config.my.office.enable;
  };
  imports = [
    ./firefox.nix
    ./tor-browser.nix
  ];
}
