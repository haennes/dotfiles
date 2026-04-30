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
  options.my.office.markup.typst.enable = mkEnableOption "typst markup language" // {
    default = config.my.office.markup.enable;
  };
  config = mkIf config.my.office.markup.typst.enable {
    environment.systemPackages = with pkgs; [
      typst
      typst-live
    ];
  };
}
