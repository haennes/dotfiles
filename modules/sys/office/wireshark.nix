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
  options.my.office.wireshark.enable = mkEnableOption "wireshark" // {
    default = config.is_client;
  };

  config = mkIf config.my.office.wireshark.enable {
    programs.wireshark = {
      dumpcap.enable = true;
      enable = true;
      usbmon.enable = true;
    };
    environment.systemPackages = with pkgs; [ wireshark ];
    users.users.hannses.extraGroups = [ "wireshark" ];
  };

}
