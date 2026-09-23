{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./gpg.nix
    ./passwords.nix
  ];
  options.my.identity.enable = mkEnableOption "identity" // {
    default = osConfig.is_client;
  };
}
