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
  options.my.utils.clipboard.enable = mkEnableOption "clipboard utils" // {
    default = config.my.utils.enable;
  };

  config = mkIf config.my.utils.clipboard.enable {
    environment.systemPackages = with pkgs; [
      wl-clipboard # clipboard
    ];
  };

}
