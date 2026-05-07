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
  options.my.oth.vpn.enable = mkEnableOption "vpn" // {
    default = config.my.oth.enable;
  };
  config = mkIf config.my.oth.vpn.enable {
    age.secrets."openfortivpn.age" = {
      file = ../../../secrets/openfortivpn.age;
      owner = "root";
      group = "root";
    };

    environment = {
      etc = {
        "openfortivpn/config".source = config.age.secrets."openfortivpn.age".path;

      };
      systemPackages = with pkgs; [ openfortivpn ];
    };
  };
}
