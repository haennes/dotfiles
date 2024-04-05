{ pkgs, lib, theme, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {  

      # disable unwanted behaviour
      add_newline = true;  

      format = "$python$directory$fossil_branch$hg_branch$pijul_channel$git_branch$docker_context$guix_shell$meson$spack$container$jobs$cmd_duration$battery $character";

      python = {
        format = "[\\($virtualenv\\)]($style) ";
      };

      directory = {
        format = "[$read_only]($read_only_style)[$path]($style)";
        style = "#${theme.color_third}";
        truncation_length = 2;
        disabled = false;
      };

      jobs = {
        format = " [$symbol$number]($style)";
        symbol = "*";
        disabled = false;
      };

      character = {    
        success_symbol = "[➜](green)";
        error_symbol = "[➜](red)";
        disabled = false;
      };

      fossil_branch = {
        format = " [$symbol$branch](bold purple)";
        disabled = false;
      };

      hg_branch = {
        format = " [$symbol$branch]($style)";
        disabled = false;
      };

      pijul_channel = {
        format = " [$symbol$channel]($style)";
        disabled = false;
      };

      git_branch = {
        format = " [$symbol$branch](bold purple)";
        disabled = false;
      };

      docker_context = {
        format = " [$symbol$context]($style)";
        disabled = false;
      };

      guix_shell = {
        format = " [$symbol]($style)";
        disabled = false;
      };

      meson = {
        format = " [$symbol$project]($style)";
        disabled = false;
      };

      spack = {
        format = " [$symbol$project]($style)";
        disabled = false;
      };

      cmd_duration = {
        format = " [$duration]($style)";
        disabled = false;
      };

      battery = {
        format = " [$symbol$percentage]($style)";
        disabled = false;
      };

      container = {
        format = " [$symbol \[$name\]]($style)";
        disabled = false;
      };

    };
  };
}
