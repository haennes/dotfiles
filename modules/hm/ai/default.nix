{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./mcp.nix
    ./mux.nix
    ./tui.nix
  ];
  options.my.ai.enable = mkEnableOption "ai" // {
    default = osConfig.is_client;
  };
}
