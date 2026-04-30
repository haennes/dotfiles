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
  options.my.office.editors.codium.enable = mkEnableOption "codium text editor" // {
    default = config.my.office.editors.enable;
  };
  config = mkIf config.my.office.editors.codium.enable {
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
  };
}
