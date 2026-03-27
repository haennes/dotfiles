{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # keep-sorted start sticky_comments=no block=yes
      #matklad.rust-analyzer
      #rust-lang.rust-analyzer
      asvetliakov.vscode-neovim
      gruntfuggly.todo-tree
      mkhl.direnv
      serayuzgur.crates
      tamasfe.even-better-toml
      usernamehw.errorlens
      # keep-sorted end
    ];
  };
}
