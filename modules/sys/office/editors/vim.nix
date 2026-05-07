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
  options.my.office.editors.vim.enable = mkEnableOption "vim text editor" // {
    default = true;
  };
  config = mkIf config.my.office.editors.vim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = false;
      #  dont set default editor here as we may want to use helix
      viAlias = true;
      vimAlias = true;
    };
  };
}
