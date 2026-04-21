{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.utils.eza.enable = mkEnableOption "pdf utils" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.eza.enable {
    environment.systemPackages = with pkgs; [
      eza
    ];

  };

}
