{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.utils.sudo.insults = mkEnableOption "use sudo insults" // {
    default = true;
  };
  config = mkIf config.my.utils.sudo.insults {
    nixpkgs.overlays = [ (final: prev: { sudo = prev.sudo.override { withInsults = true; }; }) ];
  };
}
