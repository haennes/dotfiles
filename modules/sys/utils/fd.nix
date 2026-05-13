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
  options.my.utils.fd.enable = mkEnableOption "fd" // {
    default = true;
  };
  config = mkIf config.my.utils.fd.enable {
    environment.systemPackages = with pkgs; [
      fd # better version of find
    ];
  };
}
