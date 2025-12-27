{ config, pkgs, lib, scripts, globals, joint-standalone, ... }:
let home = config.home.homeDirectory;
in {
  home.packages = with pkgs; [ nix-output-monitor eza tokei ];
  programs.zsh = {
    enable = true;
    initContent = ''
      nix() {
        if [[ $1 == "develop" ]]; then
          shift
          command nix develop -c $SHELL "$@"
        else
          command nix "$@"
        fi
      }
      catcp () {
        cat "$1" | wl-copy
      }
      mkcdir ()
        {
          mkdir -p -- "$1" &&
          cd -P -- "$1"
        }
      runc ()
        {
          gcc "$1" &&
          ./a.out
        }


    '';
    # # Yank to the system clipboard
    # function vi-yank-wlcopy {
    #     zle vi-yank
    #    echo "$CUTBUFFER" | wl-copy
    # }

    # zle -N vi-yank-wlcopy
    # bindkey -M vicmd 'y' vi-yank-wlcopy

    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "viins";
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      share = true;
      size = 10000;
    };
  };

  programs.zsh.envExtra = ''
    export FZF_DEFAULT_COMMAND="rg --files"
  ''; # respect gitignore

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = { enable = true; };
  };

}
