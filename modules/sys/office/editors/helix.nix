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
  options.my.office.editors.helix.enable = mkEnableOption "helix text editor" // {
    default = config.my.office.editors.enable;
  };
  config = mkIf config.my.office.editors.helix.enable {
    environment.systemPackages = with pkgs; [
      helix
    ];
  };
}
