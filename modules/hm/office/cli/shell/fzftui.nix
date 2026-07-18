{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    getExe
    mapAttrs
    mkIf
    mkEnableOption
    ;
  nix-search-tv = getExe pkgs.nix-search-tv;
in
{
  options.my.office.cli.shell.fzftui.enable =
    mkEnableOption "tv: A very fast, portable and hackable fuzzy finder."
    // {
      default = config.my.office.cli.shell.enable;
    };
  config = mkIf config.my.office.cli.shell.fzftui.enable {
    programs.television = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = config.programs.nushell.enable;
      channels = mapAttrs (n: v: v // { metadata.name = n; }) {

        "git-log" = {
          source.command = ''git log --oneline --date=short --pretty="format:%h %s %an %cd" "$@"'';
          preview.command = "git show -p --stat --pretty=fuller --color=always {0}";
        };
        "git-branch" = {
          source.command = ''git --no-pager branch --all --format="%(refname:short)"'';
          preview.command = "git show -p --stat --pretty=fuller --color=always {0}";
        };
        "git-diff" = {
          source.command = "git diff --name-only";
          preview.command = "git diff --color=always {0}";
        };
        "git-files" = {
          source.command = "git ls-files";
          preview.command = "bat -n --color=always {}";
        };
        "git-reflog" = {
          source.command = "git reflog";
          preview.command = "git show -p --stat --pretty=fuller --color=always {0}";
        };
        "nixpkgs" = {
          source.command = "${nix-search-tv} print";
          preview.command = "${nix-search-tv} preview {}";
        };
      };
      settings = {
        shell_integration.channel_triggers = {
          "env" = [
            "export"
            "unset"
          ];
          "dirs" = [
            "cd"
            "ls"
            "rmdir"
          ];
          # "files" = [ "mv" "cp" "vim" ];
          "git-branch" = [
            "git checkout"
            "git log"
          ];
        };
      };

    };
  };
}
