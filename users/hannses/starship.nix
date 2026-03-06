{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # add_newline = true;

      format = lib.concatStrings (
        lib.map (x: "$" + x) [
          "username"
          "directory"

          "git_branch"
          "git_commit"
          "git_state"
          "git_status"

          "container"
          "docker_context"

          "direnv"
          "nix_shell"

          "shlvl"

          "jobs"

          "zig"
          "typst"
          "rlang"
          "java"
          "python"
          "cpp"
          "c"
          "rust"

          "package"

          "status"
          "cmd_duration"
          "character"

        ]
      );

      nix_shell = {
        format = "[$symbol]($style) ";
        symbol = " ";
      };

      python = {
        format = "[\\($virtualenv\\)]($style) ";
      };

      direnv.disabled = false;

      status = {
        disabled = false;
        failure_style = "#00ff00";
        symbol = "✘";
        not_executable_symbol = "⚠";
        not_found_symbol = "∅";
        sigint_symbol = "⏸";
        signal_symbol = "⚑";
      };

      os.disabled = false;

      shlvl = {
        disabled = false;
        symbol = " ";
      };

      cpp = {
        format = "via [$name $version]($style) ";
        style = "#f00000";
        disabled = false;
      };

      directory = {
        format = "[$read_only]($read_only_style)[$path]($style) ";
        read_only = "⚿ ";
        read_only_style = "green";
        style = "red";
        truncation_length = 4;
        disabled = false;
      };

      jobs = {
        format = "[$symbol$number]($style) ";
        symbol = "∗";
        disabled = false;
      };

      character = {
        success_symbol = "[➜](red)";
        error_symbol = "[➜](green)";
        disabled = false;
      };

      git_branch = {
        format = "[$symbol$branch](yellow) ";
        disabled = false;
      };

      docker_context = {
        format = "[$symbol$context]($style) ";
        disabled = false;
      };

      cmd_duration = {
        format = " [$duration]($style) ";
        disabled = false;
      };

      container = {
        format = " [$symbol [$name]]($style) ";
        disabled = false;
      };
      # disable unwanted behaviour
      add_newline = true;
    };
  };
}
