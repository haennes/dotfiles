{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    inputs.git-opencode-plugin.homeManagerModules.opencode-git-tools
    # keep-sorted end
  ];
  options.my.ai.tui.enable = mkEnableOption "ai agent tui" // {
    default = config.my.ai.enable;
  };
  config = mkIf config.my.ai.tui.enable {
    programs.opencode-git-tools.enable = true;
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        permission = {
          "*" = "ask";
          "bash" = {
            "*" = "ask";
            "git add *" = "allow";
            "nix build *" = "allow";
            "nix flake check *" = "allow";
            "nix flake metadata *" = "allow";
            "nix log *" = "allow";
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
          "webfetch" = "deny";
          "websearch" = "deny";
        };
      };
      context = builtins.concatStringsSep "\n" (
        lib.flatten [
          "never access nix store paths directly or search through the nix store. either use piping or use nix build"
          ""
          "- Do not use the bash tool unless strictly necessary."
          "- Commands that always pass (no confirmation needed):"
          (lib.mapAttrsToList (n: _: "  - ${n}")
            (lib.filterAttrs(_: v: v == "allow")
            config.programs.opencode.settings.permission.bash))
        ]
      );
    };
  };
}
