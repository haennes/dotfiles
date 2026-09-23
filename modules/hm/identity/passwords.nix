{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.identity.passwords.enable = mkEnableOption "passwords manager" // {
    default = config.my.identity.enable;
  };
  config = mkIf config.my.identity.passwords.enable {
    programs.keepassxc = {
      enable = true;
    };
  };
}
