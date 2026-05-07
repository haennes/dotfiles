{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.identity.hwtoken.enable = mkEnableOption "yubikey" // {
    default = config.my.identity.enable;
  };
  config = mkIf config.my.identity.hwtoken.enable {

    environment.systemPackages = with pkgs; [ yubikey-manager ];
    services.udev.packages = with pkgs; [ yubikey-personalization ];
  };

}
