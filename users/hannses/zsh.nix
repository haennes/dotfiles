{ config, pkgs, lib, scripts, ... }:
let
  home = config.home.homeDirectory;
  dotfiles_path = "${home}/.dotfiles";
in {
  home.packages = with pkgs; [ nom eza tokei ];
  programs.zsh = {
    enable = true;
    shellAliases = let
      aliases = [ "dticket" "ticket" "db" ];
      semester1 = "cd ${home}/Documents/Studium/Semester1";
      semester2 = "cd ${home}/Documents/Studium/Semester2";

    in rec {
      #manix and its aliases are configured in ./manix.nix
      dbui = "${scripts.dbui_fzf}";
      gcpp = "${scripts.gcpp}";

      loc = "${pkgs.tokei}/bin/tokei";
      bc = "${pkgs.fend}/bin/fend";

      dpdf = "${pkgs.diff-pdf}/bin/diff-pdf --view";

      rg = "${pkgs.ripgrep-all}/bin/rga";

      nix-build = "${pkgs.nix-output-monitor}/bin/nom-build";
      nix-shell = "${pkgs.nix-output-monitor}/bin/nom-shell";

      #settings this to pkgs fails
      vim = "nvim";
      vi = "nvim";

      ls = "${pkgs.eza}/bin/eza -lh";
      sl = ls;
      la = "${ls} -A";

      df = "${pkgs.duf}/bin/duf";
      # path cds
      dotfiles = "cd ${dotfiles_path}";
      dotf = dotfiles;

      oth = semester2;
      down = "cd ${home}/Downloads";

      pro = "cd ${home}/programming";

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

      "..." = "cd  ../../"; # dont want to enable prezto
      "...." = "cd  ../../../"; # dont want to enable prezto
      "....." = "cd  ../../../../"; # dont want to enable prezto
      "......" = "cd  ../../../../../"; # dont want to enable prezto
      # ...... seems more than enough

      # config apply & build
      cfg_apply = "${dotfiles_path}/apply";
      cfg_update = "pushd ${dotfiles_path} && ${dotfiles_path}/update && popd";

      # vim keybindings
      ":q" = "exit";

      udmount = "udiskctl mount -b";
      udumount = "udiskctl umount -b";
      mount_phone = "${pkgs.jmtpfs}/bin/jmtpfs";

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
    initExtra = ''
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

    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "vicmd";
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      share = true;
      size = 10000;
    };
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = { enable = true; };
  };
  programs.thefuck.enable = true;
}
