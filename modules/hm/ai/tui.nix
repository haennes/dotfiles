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
          "when running a command always save the *entire* stderr + stdout logs to the local dir ./.logs, reference them for future use, do not read them with bash tools (see below)"
          "make sure ./.logs is git excluded -> not .gitignore but in the exclude file: .git/info/exclude"
          "whishes: if you have any whishes like: i whish i had a tool to do xyz use taskwarrior command to create a task for that"
          "lessons learned: if you have a lesson learned (i.e. by me making adjustments) check if ~/.dotfiles/modules/hm/ai/tui.nix already has that and otherwise do the edit"
          ""
          "- Do not use the bash tool unless strictly necessary."
          "- do not use ls use glob tool instead"
          "- Commands that always pass (no confirmation needed):"
          (lib.mapAttrsToList (n: _: "  - ${n}")
            (lib.filterAttrs(_: v: v == "allow")
            config.programs.opencode.settings.permission.bash))
        ]
      );
    };
  };
}
