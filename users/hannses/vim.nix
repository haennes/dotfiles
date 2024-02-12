{ pkgs, nixvim, ... }: {
  imports = [ nixvim.homeManagerModules.nixvim ];
  #programs.neovim = { 
  #managed by nixvim
  #    enable = true;
  # declared in zsh.nix
  #    viAlias = true;
  #    vimAlias = true;
  #};
  programs.nixvim = {
    enable = true;
    options = {
      number = true;
      relativenumber = true;
      #absolutenumber = true;
      shiftwidth = 2;
      autochdir = true;
      autoindent = true;
      autoread = true;
      clipboard = "unnamedplus";
      #icon  = true;
      title = true;
    };
    plugins = {
      typst-vim = { enable = true; };

      markdown-preview = {
        enable = true;
        autoStart = true; # TODO figure out command
      };
      openscad = {
        enable = true;
        autoOpen = true;
      };

      treesitter.enable = true;
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          typst-lsp.enable = true; 

          rust-analyzer = {
            installRustc = true;
            installCargo = true;
            enable = true;
          };
        };
      };
      lsp-format.enable = true;
    };
    colorschemes.gruvbox.enable = true;
  };
}
