{ pkgs, nixvim, config, scripts, ... }: {
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
    opts = {
      number = true;
      relativenumber = true;
      #absolutenumber = true;
      shiftwidth = 2;
      autochdir = true;
      autoindent = true;
      autoread = true;
      clipboard = "unnamedplus";
      expandtab = true;
      #icon  = true;
      title = true;
    };
    clipboard.providers.wl-copy.enable = true;
    autoCmd = [
      # Termdebug
      { 
        event = "VimEnter";
        command = "packadd termdebug";
      }
      
      # from https://github.com/GaetanLepage/nix-config/blob/master/home/modules/tui/neovim/autocommands.nix
      # Remove trailing whitespace on save
      {
          event = "BufWrite";
          command = "%s/\\s\\+$//e";
      }
      # Enable spellcheck for some filetypes
      {
          event = "FileType";
          pattern = [
              "tex"
              "latex"
              "markdown"
          ];
          command = "setlocal spell spelllang=en,de";
      }
    ];
    plugins = {
      neogit = {
        enable = true;
      };
      typst-vim = {
        enable = true;
        settings.cmd = "${scripts.typst-live-custom}";
        #"${config.home.packages.typst-watch-to-typst-live}" ;
        #"${config.environment.systemPackages.typst-watch-to-typst-live}" ;
      };

      markdown-preview = {
        enable = true;
        settings.auto_start = true;
      };
      openscad = {
        enable = true;
        #autoOpen = true;
        keymaps.enable = true;
        keymaps.execOpenSCADTrigger = "<A-o>";
      };

      comment.enable = true;
      treesitter.enable = true;
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          typst-lsp.enable = true;

          clangd.enable = true;
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
    keymaps = [
      # Those are somewhat doom-emacs keybinds...
      {
        # Escape out of terminal
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
      }
      {
	# Escape to remove highlight
	mode = "n";
	key = "<Esc>";
	action = ":noh<CR>";
	options.silent = true;
      }
    ];
  };
}
