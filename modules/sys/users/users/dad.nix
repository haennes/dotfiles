{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.my) genUser;
in
{
  options.my.users.dad.enable = mkEnableOption "add user dad" // {
    default = config.is_client;
  };
  config = mkIf config.my.users.dad.enable {
    users.users = (genUser "dad");
  };
}
