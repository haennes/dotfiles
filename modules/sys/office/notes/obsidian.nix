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
  options.my.office.notes.obsidian.enable = mkEnableOption "obsidian" // {
    default = config.my.office.notes.enable;
  };
  config = mkIf config.my.office.notes.obsidian.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
