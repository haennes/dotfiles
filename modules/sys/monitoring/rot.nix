{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.monitoring.rot = {
    enable = mkEnableOption "system out of date detection" // {
      default = config.my.monitoring.enable;
    };
    enableBackend = mkEnableOption "create appropiate user" // {
      default = config.my.monitoring.rot.enable;
    };
    enableClient = mkEnableOption "add rot check script to path" // {
      default = config.my.monitoring.rot.enable && config.is_client;
    };
  };
  config = mkIf config.my.monitoring.rot.enable {
    services.rotcheck = mkIf config.my.monitoring.rot.enableBackend { 
      enable = true;
      privateKeyFile = config.age.secrets."rot-ssh.age".path;
    };
    age.secrets."rot-ssh.age" = {
     file = ../../../secrets/rot-ssh.age;
     owner = config.services.rotcheck.userName;
    };
    services.rotcheckClient = mkIf config.my.monitoring.rot.enableClient {
      enable = true;
      user = "hannses";
      privateKeyFile = config.age.secrets."rot-ssh.age".path;
    };
  };

}
