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
  options.my.utils.dll.enable = mkEnableOption "dll" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.dll.enable {
    environment.systemPackages = with pkgs; [ nix-alien ];
    # Optional, needed for `nix-alien-ld`
    programs.nix-ld.enable = true;
  };
}
