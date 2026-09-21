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
          navigate_workspace_up = "k";
          navigate_workspace_down = "j";
          next_workspace = "n";
          previous_workspace = "p";
          next_agent = "h";
          previous_agent = "l";
        };
        onboarding = false;
        ui.prompt_new_workspace_name = true;
        experimental.kitty_graphics = true;
      };
    };
  };
}
