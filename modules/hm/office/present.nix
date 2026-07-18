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
  options.my.office.present.enable = mkEnableOption "presentation software" // {
    default = config.my.office.enable;
  };
  config = mkIf config.my.office.present.enable {
    home.packages = with pkgs; [
      pdfpc
    ];
  };
}
