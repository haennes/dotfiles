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
  options.my.utils.archive.enable = mkEnableOption "archive utils" // {
    default = config.my.utils.enable;
  };

  config = mkIf config.my.utils.archive.enable {
    environment.systemPackages = with pkgs; [
      zip
      unzip
    ];
  };

}
