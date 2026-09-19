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
  options.my.ai.mux.enable = mkEnableOption "multiplexer for ai agents" // {
    default = config.my.ai.enable;
  };
  config = mkIf config.my.ai.mux.enable {
    programs.herdr = {
      enable = true;
      settings = {
        keys = {
          next_workspace = "prefix+j";
          previous_workspace = "prefix+k";
          next_agent = "prefix+J";
          previous_agent = "prefix+K";
        };
        onboarding = false;
        ui.prompt_new_workspace_name = true;
        experimental.kitty_graphics = true;
      };
    };
  };
}
