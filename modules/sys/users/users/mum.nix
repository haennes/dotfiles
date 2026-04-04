{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.my) genUser;
in
{
  options.my.users.mum.enable = mkEnableOption "add user mum" // {
    default = config.is_client;
  };
  config = mkIf config.my.users.mum.enable {
    users.users = (genUser "mum");
  };
}
