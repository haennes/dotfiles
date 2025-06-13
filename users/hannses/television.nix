{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
  nix-search-tv = getExe pkgs.nix-search-tv;
in {
  programs.television = {
    enable = true;
    enableZshIntegration = true;
    channels.custome-one.cable_channel = [

      {
        name = "git-log";
        source_command = ''
          git log --oneline --date=short --pretty="format:%h %s %an %cd" "$@"'';
        preview_command =
          "git show -p --stat --pretty=fuller --color=always {0}";
      }
      {
        name = "git-branch";
        source_command =
          ''git --no-pager branch --all --format="%(refname:short)"'';
        preview_command =
          "git show -p --stat --pretty=fuller --color=always {0}";
      }
      {
        name = "git-diff";
        source_command = "git diff --name-only";
        preview_command = "git diff --color=always {0}";
      }
      {
        name = "git-files";
        source_command = "git ls-files";
        preview_command = "bat -n --color=always {}";
      }
      {
        name = "git-reflog";
        source_command = "git reflog";
        preview_command =
          "git show -p --stat --pretty=fuller --color=always {0}";
      }
      {
        name = "nixpkgs";
        source_command = "${nix-search-tv} print";
        preview_command = "${nix-search-tv} preview {}";
      }
    ];
    settings = {
      shell_integration.channel_triggers = {
        "env" = [ "export" "unset" ];
        "dirs" = [ "cd" "ls" "rmdir" ];
        "files" = [ "mv" "cp" "vim" ];
        "git-branch" = [ "git checkout" "git log" ];
      };
    };

  };
}
