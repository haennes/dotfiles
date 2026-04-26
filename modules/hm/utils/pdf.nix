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
  options.my.utils.pdf.enable = mkEnableOption "pdf" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.pdf.enable {
    home.packages = with pkgs; [
      poppler-utils
      pdftk
      diff-pdf
    ];
  };
}
