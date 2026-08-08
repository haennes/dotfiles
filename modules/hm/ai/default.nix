{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./mux.nix
    ./tui.nix
  ];
  options.my.ai.enable = mkEnableOption "ai" // {
    default = osConfig.is_client;
  };
}
