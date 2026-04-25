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
  options.my.utils.networking.enable = mkEnableOption "networking" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.networking.enable {
    environment.systemPackages = with pkgs; [
      nmap
      wget
      dig # dns lookup
      tcpdump
      wireguard-tools
    ];
  };
}
