{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
              # keep-sorted start
      mkhl.direnv
      #matklad.rust-analyzer
      #rust-lang.rust-analyzer
      serayuzgur.crates
      tamasfe.even-better-toml
      usernamehw.errorlens
      gruntfuggly.todo-tree
      asvetliakov.vscode-neovim
              # keep-sorted end
    ];
  };
}
