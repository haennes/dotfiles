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
  options.my.office.notes.xournalpp.enable = mkEnableOption "xournalpp" // {
    default = config.my.office.notes.enable;
  };
  config = mkIf config.my.office.notes.xournalpp.enable {
    environment.systemPackages = with pkgs; [
      xournalpp
    ];
  };
}
