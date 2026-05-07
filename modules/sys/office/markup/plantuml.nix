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
  options.my.office.markup.plantuml.enable = mkEnableOption "plantuml markup language" // {
    default = config.my.office.markup.enable;
  };
  config = mkIf config.my.office.markup.typst.enable {
    environment.systemPackages = with pkgs; [ plantuml-c4 ];
  };
}
