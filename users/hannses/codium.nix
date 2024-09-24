{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      mkhl.direnv
      #matklad.rust-analyzer
      #rust-lang.rust-analyzer
      serayuzgur.crates
      tamasfe.even-better-toml
      usernamehw.errorlens
      gruntfuggly.todo-tree
      asvetliakov.vscode-neovim
    ];
  };
}
