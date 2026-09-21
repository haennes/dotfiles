{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    inputs.mcp-servers-nix.homeManagerModules.default
    # keep-sorted end
  ];
  options.my.ai.mcp.enable = mkEnableOption "shared mcp servers" // {
    default = config.my.ai.enable;
  };
  config = mkIf config.my.ai.mcp.enable {
    programs.mcp.enable = true;
    mcp-servers.programs = {
      nixos.enable = true;
    };
  };
}
