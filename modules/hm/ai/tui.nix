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
  options.my.ai.tui.enable = mkEnableOption "ai agent tui" // {
    default = config.my.ai.enable;
  };
  config = mkIf config.my.ai.tui.enable {
    programs.opencode = {
      enable = true;
      settings = {
        permission = {
          "*" = "ask";
          "bash" = {
            "*" = "ask";
            "git add *" = "allow";
            "nix build *" = "allow";
            "grep *" = "allow";
          };
          "edit" = "allow";
          "write" = "allow";
          "read" = "allow";
          "grep" = "allow";
          "glob" = "allow";
          "lsp" = "allow";
          "apply_patch" = "allow";
          "skill" = "allow";
          "todowrite" = "allow";
          "question" = "allow";
        };
      };
    };
  };
}
