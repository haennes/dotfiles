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
          navigate_workspace_up = "prefix+k";
          navigate_workspace_down = "prefix+j";
          next_workspace = "prefix+h";
          previous_workspace = "prefix+l";
          next_agent = "prefix+H";
          previous_agent = "prefix+L";
        };
        onboarding = false;
        ui.prompt_new_workspace_name = true;
        experimental.kitty_graphics = true;
      };
    };
  };
}
