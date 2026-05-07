{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.identity.enable = mkEnableOption "identity" // {
    default = config.is_client;
  };

  imports = [
    ./keyring.nix
  ];

}
