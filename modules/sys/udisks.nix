{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.udisks.enable = mkEnableOption "udisks2" // {
    default = config.is_client;
  };
  config = mkIf config.my.udisks.enable {
    services.udisks2.enable = true;
  };
}
