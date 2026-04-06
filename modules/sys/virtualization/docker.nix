{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.virtualization.docker.enable = mkEnableOption "docker" // {
    default = config.is_client;
  };
  config = mkIf config.my.virtualization.docker.enable {
    virtualisation.docker.enable = true;
  };
}
