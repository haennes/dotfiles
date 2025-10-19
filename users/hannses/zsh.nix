{ config, pkgs, lib, scripts, globals, joint-standalone, ... }:
let home = config.home.homeDirectory;
in {
  home.packages = with pkgs; [ nix-output-monitor eza tokei ];
  programs.zsh = {
    enable = true;
    shellAliases = let
      aliases = [ "dticket" "ticket" ];
      studium = "${home}/Documents/Studium";
      semester1 = "${studium}/Semester1";
      semester2 = "${studium}/Semester2";
      semester3 = "${studium}/Semester3";
      semester4 = "${studium}/Semester4";

    in rec {
      dbui = "${scripts.dbui_fzf}";
      gcpp = "${scripts.gcpp}";

      wwhich = "${scripts.wwhich}";

      loc = "${pkgs.tokei}/bin/tokei";

      dpdf = "${pkgs.diff-pdf}/bin/diff-pdf --view";

      rg = "${pkgs.ripgrep-all}/bin/rga";

      nix-build = "${pkgs.nix-output-monitor}/bin/nom-build --run $SHELL";
      nix-shell = "${pkgs.nix-output-monitor}/bin/nom-shell --run $SHELL";

      #settings this to pkgs fails
      vim = "nvim";
      vi = "nvim";

      ls = "${pkgs.eza}/bin/eza -lh";
      sl = ls;
      la = "${ls} -A";

      df = "${pkgs.duf}/bin/duf";
      # path cds
      dotfiles = "cd ${globals.dotfiles_path}";
      dotf = dotfiles;

      oth = semester4;
      down = "cd ${home}/Downloads";

      pro = "cd ${home}/programming";

      fsim = "${studium}/FSIM";
      # Semester 1
      pg1 = "${semester1}/PG1";
      ma1 = "${semester1}/MA1";
      ph = "${semester1}/PH1";
      ti = "${semester1}/TI1";
      uws = "${semester1}/Umweltschutz_Einfuehrung";

      # Semester 2
      cs = "${semester2}/CS";
      ma = "${semester2}/MA2";
      rb = "${semester2}/RB";
      ge = "${semester2}/GE";
      pg = "${semester2}/PG2";

      # Semester 3
      ad = "${semester3}/AD";
      em = "${semester3}/EM";
      se = "${semester3}/SE";
      st = "${semester3}/ST";
      zock = "${semester3}/ZOCK/group";

      ks = "${semester4}/KS";
      os = "${semester4}/OS";
      DD = "${semester4}/DD";
      db = "${semester4}/DB";
      tt = "${semester4}/TTPG2";

      "..." = "cd  ../../"; # dont want to enable prezto
      "...." = "cd  ../../../"; # dont want to enable prezto
      "....." = "cd  ../../../../"; # dont want to enable prezto
      "......" = "cd  ../../../../../"; # dont want to enable prezto
      # ...... seems more than enough

      # config apply & build
      cfg_apply = "${globals.dotfiles_path}/apply";
      cfg_update =
        "pushd ${globals.dotfiles_path} && ${globals.dotfiles_path}/update && popd";
      fs_cfg_sync =
        let path = "/home/hannses/Documents/Studium/FSIM/server-pedro";
        in "rsync -r fs_main:/etc/nixos/ ${path}";

      fs_cfg_sync_jmp =
        let path = "/home/hannses/Documents/Studium/FSIM/server-pedro";
        in "rsync -r fs_main_jmp:/etc/nixos/ ${path}";

      # vim keybindings
      ":q" = "exit";

      udmount = "udiskctl mount -b";
      udumount = "udiskctl umount -b";
      mount_phone = "${pkgs.jmtpfs}/bin/jmtpfs";

      cat_tests = "${joint-standalone.c_cat_tests}";
      edit_tests = "${joint-standalone.c_edit_tests}";
      gen_tests = "${joint-standalone.c_gen_tests}";
      run_tests = "${joint-standalone.c_run_tests}";

      ttask = lib.getExe pkgs.taskwarrior-tui;

    } // lib.listToAttrs (lib.flatten (lib.lists.map (name: [
      {
        name = "${name}_bak";
        value = "${scripts.deutschland_ticket_pdf}";
      }
      {
        name = "${name}_bak_bak";
        value = "${scripts.deutschland_ticket_screenshot}";
      }
      {
        name = name;
        value = "${scripts.deutschland_ticket_firefox}";
      }
    ]) aliases));
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
