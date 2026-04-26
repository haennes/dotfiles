{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./gpg.nix
  ];
  options.my.identity.enable = mkEnableOption "identity" // {
    default = osConfig.is_client;
  };
}
