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
  options.my.utils.pdf.enable = mkEnableOption "pdf utils" // {
    default = config.my.utils.enable;
  };

  config = mkIf config.my.utils.pdf.enable {
    environment.systemPackages = with pkgs; [
      diff-pdf
      pdfarranger
    ];
  };

}
