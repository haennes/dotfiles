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
  };
  config = mkIf config.my.monitoring.rot.enable {
    services.rotcheck = mkIf config.my.monitoring.rot.enableBackend { 
      enable = true;
    };
    age.secrets."rot-ssh.age" = {
     file = ../../../secrets/rot-ssh.age;
     owner = config.services.rotcheck.userName;
    };
  };

}
