{ nixvim, pkgs, scripts, ... }: {
  imports = [ nixvim.homeModules.nixvim ];

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
        pattern = [ "tex" "latex" "markdown" ];
        command = "setlocal spell spelllang=en,de";
      }
    ];
    plugins = {
      neogit = { enable = true; };
      yazi = {
        enable = true;
        settings.open_for_directories = true;
      };
      flash = { enable = true; };
      typst-vim = {
        enable = true;
        settings.pdf_viewer = "${pkgs.zathura}/bin/zathura";
        keymaps.watch = "<leader>tw";
      };

      markdown-preview = {
        enable = true;
        settings = {
          auto_start = 0;
          auto_close = 0;
        };
      };
      openscad = {
        enable = true;
        settings = {
          auto_open = true;
          exec_openscad_trig_key = "<A-o>";
        };
      };
      telescope = {
        enable = true;
        #extensions = { fzf-native.enable = true; };
        keymaps = {
          "<leader>gf" = {
            action = "git_files";
            options = { desc = "Telescope Git Files"; };
          };
          "<leader>fg" = "live_grep";
        };
      };
      web-devicons.enable = true;

      comment.enable = true;
      treesitter.enable = true;
      lsp = {
        enable = true;
        servers = {
          nixd = {
            enable = true;
            settings.formatting.command = [ "nix" "fmt" "--" "--" ];
          };
          tinymist.enable = true;

          clangd.enable = true;
          rust_analyzer = {
            installRustc = true;
            installCargo = true;
            enable = true;
          };
        };
        keymaps = {
          silent = true;
          lspBuf = {
            gd = {
              action = "definition";
              desc = "[G]oto [D]definition";
            };
            gr = {
              action = "references";
              desc = "[G]oto [R]eferences";
            };
            gD = {
              action = "declaration";
              desc = "[G]oto [D]eclaration";
            };
            "<leader>gI" = {
              action = "implementation";
              desc = "[G]oto [I]mplementation";
            };
          };
        };
      };
      lsp-format.enable = true;
      lspsaga = { enable = true; };
    };

    colorschemes.gruvbox.enable = true;
    globals.mapleader = " ";
    keymaps = [
      # Those are somewhat doom-emacs keybinds...
      {
        # Neogit
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Neogit<CR>";
      }
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
      {
        # better indent in visual mode
        mode = "v";
        key = ">";
        action = ">gv";
      }
      {
        # better unindent in visual mode
        mode = "v";
        key = "<";
        action = "<gv";
      }
    ];
  };
}
