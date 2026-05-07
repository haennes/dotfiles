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
  options.my.office.notes.libreoffice.enable = mkEnableOption "libreoffice wsgi office" // {
    default = config.my.office.notes.enable;
  };
  config = mkIf config.my.office.notes.libreoffice.enable {
    environment.systemPackages = with pkgs; [
      libreoffice
    ];
  };
}
